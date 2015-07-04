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
	'click i': ->
		isAddingANewChannel.set false

	'submit form.form': (event) ->
		channel = event.target.channel.value
		if channel
			Meteor.call 'addChannel', channel, (error, result) ->
				if error
					Session.set 'error', error
				else
					isAddingANewChannel.set false
		# prevent default form submit
		false

Template.menu_addNewChannelItem.onRendered ->
	@$('input').focus()

################################################################################
# _channelItem
################################################################################
Template.menu_channelItem.helpers
	channelClass: (name) ->
		return 'item' if not Session.get 'isChatting'

		if Session.equals 'currentChannel', name
			'item active'
		else
			'item'

################################################################################
# _createNewChannelItem
################################################################################
Template.menu_createNewChannelItem.events
	'click': ->
		isAddingANewChannel.set true
