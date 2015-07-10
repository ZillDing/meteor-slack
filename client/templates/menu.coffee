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
		text = event.currentTarget.value.toLowerCase()
		# only search when the input value changes
		if text isnt template.prevSearchValue
			handle = template.prevTimeoutHandle
			Meteor.clearTimeout handle if handle
			template.prevSearchValue = text
			template.prevTimeoutHandle = Meteor.setTimeout ->
				pattern = new RegExp text.split('').join('.*'), 'i'
				template.searchPattern.set pattern
			, 300

Template.menu_addNewDirectChatItem.helpers
	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
			username: Template.instance().searchPattern.get()
		,
			sort:
				username: 1

Template.menu_addNewDirectChatItem.onCreated ->
	@subscribe 'allUsers', =>
		@searchPattern = new ReactiveVar /.*/i

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
