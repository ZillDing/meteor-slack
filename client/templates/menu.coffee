isAddingANewChannel = new ReactiveVar false
isAddingANewDirectChat = new ReactiveVar true

Template.menu.helpers
	channels: ->
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
Template.menu_addNewDirectChatItem.events
	'click i.cancel': ->
		isAddingANewDirectChat.set false

Template.menu_addNewDirectChatItem.onRendered ->
	@$('input').focus()
