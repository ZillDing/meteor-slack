isAddingANewChannel = new ReactiveVar false
isAddingANewDirectChat = new ReactiveVar false

Template.menu.helpers
	channels: ->
		if Meteor.userId()
			UserData.findOne
				owner: Meteor.userId()
			.data.channel
		else
			Channels.find {}

	isAddingANewChannel: ->
		isAddingANewChannel.get()

	isAddingANewDirectChat: ->
		isAddingANewDirectChat.get()

################################################################################
# _channelItem
################################################################################
Template.menu_channelItem.helpers
	channelClass: (name) ->
		return '' if not Session.get 'isChatting'
		return '' if not Session.equals 'chatType', 'channel'

		if Session.equals 'chatTarget', name
			'active'
		else
			''

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
					_addNotification
						type: 'error'
						header: error.error
						message: error.message
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
filteredUsers = new ReactiveVar()
prevSearchValue = '' # always lower case
prevTimeoutHandle = null
searchUser = ($input) ->
	text = $input.val().toLowerCase()
	# use fuzzy search
	pattern = new RegExp text.split('').join('.*'), 'i'

	filteredUsers.set Meteor.users.find
		_id:
			$ne: Meteor.userId()
		username: pattern
	,
		sort:
			username: 1
	prevSearchValue = text
	prevTimeoutHandle = null

Template.menu_addNewDirectChatItem.events
	'click a.sidebar-menu-item': ->
		isAddingANewDirectChat.set false

	'click i.cancel': ->
		isAddingANewDirectChat.set false

	'keyup input': (event) ->
		if prevSearchValue isnt event.currentTarget.value.toLowerCase()
			Meteor.clearTimeout prevTimeoutHandle if prevTimeoutHandle
			prevTimeoutHandle = Meteor.setTimeout ->
				searchUser $ event.currentTarget
			, 300

Template.menu_addNewDirectChatItem.helpers
	users: ->
		filteredUsers.get()

Template.menu_addNewDirectChatItem.onCreated ->
	filteredUsers.set Meteor.users.find
		_id:
			$ne: Meteor.userId()
	,
		sort:
			username: 1

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
