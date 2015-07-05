isAddingANewChannel = new ReactiveVar false

Template.menu.helpers
	channels: ->
		Channels.find {}

	isAddingANewChannel: ->
		isAddingANewChannel.get()

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
					Session.set 'error', error
				else
					isAddingANewChannel.set false

	'click i': ->
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
# _channelItem
################################################################################
Template.menu_channelItem.helpers
	channelClass: (name) ->
		return 'item' if not Session.get 'isChatting'
		return 'item' if not Session.equals 'chatType', 'channel'

		if Session.equals 'chatTarget', name
			'item active'
		else
			'item'

################################################################################
# _createNewChannelItem
################################################################################
Template.menu_createNewChannelItem.events
	'click': ->
		isAddingANewChannel.set true
