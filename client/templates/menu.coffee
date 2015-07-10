isAddingANewChannel = new ReactiveVar false
isAddingANewDirectChat = new ReactiveVar false

Template.menu.helpers
	channels: ->
		if Meteor.user()?.data
			UserData.findOne(Meteor.user().data).channel
		else
			Channels.find {}

	directChats: ->
		if Meteor.user()?.data
			UserData.findOne(Meteor.user().data).direct.reverse()

	isAddingANewChannel: ->
		isAddingANewChannel.get()

	isAddingANewDirectChat: ->
		isAddingANewDirectChat.get()

Template.menu.onCreated ->
	@autorun =>
		if Meteor.userId()
			@subscribe 'currentUser'
		else
			@subscribe 'channels'

################################################################################
# _createNewChannelItem
################################################################################
Template.menu_createNewChannelItem.events
	'click': ->
		isAddingANewChannel.set true

################################################################################
# _addNewChannelItem
################################################################################
Template.menu_addNewChannelItem.events
	'click .cancel-btn': ->
		Template.instance().$('div.item').popup 'hide'

	'click .confirm-btn': ->
		Template.instance().$('div.item').popup 'hide'
		channel = Template.instance().$('input').val()
		if channel
			Meteor.call 'addChannel', channel, (error, result) ->
				if error
					_addErrorNotification error
				else
					isAddingANewChannel.set false

	'click i.cancel': ->
		isAddingANewChannel.set false

	'submit form.form': ->
		if Template.instance().$('input').val()
			Template.instance().$('div.item').popup 'show'
		# prevent default form submit
		false

Template.menu_addNewChannelItem.onRendered ->
	@$('div.item').popup
		# inline: true
		popup: @$('.ui.popup')
		on: 'manual'
		position: 'bottom left'
	@$('input').focus()


################################################################################
# _createNewDirectChatItem
################################################################################
Template.menu_createNewDirectChatItem.events
	'click': ->
		isAddingANewDirectChat.set true

################################################################################
# _addNewDirectChatItem
################################################################################
Template.menu_addNewDirectChatItem.events
	'click a.sidebar-menu-item': ->
		isAddingANewDirectChat.set false

	'click i.cancel': ->
		isAddingANewDirectChat.set false

	'keyup input': (event, template) ->
		value = template.prevSearchValue
		handle = template.prevTimeoutHandle
		if value isnt event.currentTarget.value.toLowerCase()
			Meteor.clearTimeout handle if handle
			template.prevTimeoutHandle = Meteor.setTimeout ->
				template.searchUser $ event.currentTarget
			, 300

Template.menu_addNewDirectChatItem.helpers
	users: ->
		Template.instance().filteredUsers.get()

Template.menu_addNewDirectChatItem.onCreated ->
	@subscribe 'allUsers', =>
		users = Meteor.users.find
			_id:
				$ne: Meteor.userId()
		,
			sort:
				username: 1
		@filteredUsers = new ReactiveVar users
		@prevSearchValue = '' # always lower case
		@prevTimeoutHandle = null
		@searchUser = ($input) =>
			text = $input.val().toLowerCase()
			# use fuzzy search
			pattern = new RegExp text.split('').join('.*'), 'i'

			@filteredUsers.set Meteor.users.find
				_id:
					$ne: Meteor.userId()
				username: pattern
			,
				sort:
					username: 1
			@prevSearchValue = text
			@prevTimeoutHandle = null

Template.menu_addNewDirectChatItem.onRendered ->
	@$('input').focus()

################################################################################
# _addNewDirectChatItem_userItem
################################################################################
Template.menu_addNewDirectChatItem_userItem.helpers
	statusLabelColor: ->
		if Template.currentData().status?.online
		then 'green'
		else 'grey'
