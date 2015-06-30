Template.messages.helpers
	messages: ->
		Messages.find {}

Template.messages.onCreated ->
	@autorun =>
		data = Template.currentData()
		if data?.channel and _.isString data.channel
			@subscribe 'messagesInChannel', data.channel
			Session.set 'currentChannel', data.channel
