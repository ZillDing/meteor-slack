Template.menu.helpers
	channels: ->
		Channels.find {}

	isAddingANewChannel: ->
		Session.get 'isAddingANewChannel'

################################################################################
# _addNewChannelItem
################################################################################
Template.menu_addNewChannelItem.events
	'click i': ->
		Session.set 'isAddingANewChannel', false

	'keypress input': (event) ->
		if event.which is 13
			channel = event.currentTarget.value.trim().toLowerCase()
			if channel
				Meteor.call 'addChannel', channel
				Session.set 'isAddingANewChannel', false

Template.menu_addNewChannelItem.onRendered ->
	@$('input').focus()

################################################################################
# _channelItem
################################################################################
Template.menu_channelItem.helpers
	isCurrentChannel: ->
		Template.currentData()?.name is Session.get 'currentChannel'

################################################################################
# _createNewChannelItem
################################################################################
Template.menu_createNewChannelItem.events
	'click': ->
		Session.set 'isAddingANewChannel', true
