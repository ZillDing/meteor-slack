Template.messages.helpers
	messages: ->
		Messages.find {}

Template.messages.onCreated ->
	@autorun =>
		@subscribe 'messagesInChannel', Session.get 'currentChannel'
