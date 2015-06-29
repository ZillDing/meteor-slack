Template.messages.helpers
	messages: ->
		Messages.find {}

Template.messages.onCreated ->
	@autorun =>
		if channel = Template.currentData()?.channel
			Session.set 'currentChannel', channel
			@subscribe 'messagesInChannel', channel
