Template.title.helpers
	channels: ->
		Channels.find {}

	currentChannel: ->
		Session.get 'currentChannel'

Template.title.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		transition: 'drop'
