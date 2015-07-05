Template.messages.helpers
	messages: ->
		Messages.find {}

Template.messages.onCreated ->
	Session.set 'isChatting', true
	@autorun =>
		data = Template.currentData()
		if (_.isObject data) and not _.isEmpty data
			@subscribe 'targetedMessages', data
			Session.set
				chatType: data.type
				chatTarget: data.target

Template.messages.onDestroyed ->
	Session.set 'isChatting', false
