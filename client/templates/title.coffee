Template.title.helpers
	channels: ->
		Channels.find {}

	currentTarget: ->
		Session.get 'chatTarget'

Template.title.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		transition: 'drop'
