Router.configure
	layoutTemplate: 'layout'

Router.route '/', ->
	if Meteor.userId()
		@redirect '/channel/general'
	else
		@redirect '/signin'

Router.route '/channel/:_channel', ->
	channel = @params._channel
	@render 'messages',
		data:
			channel: channel
	Session.set 'isChatting', true

Router.route '/profile', ->
	@render 'profile'
	Session.set 'isChatting', false

Router.route '/signin', ->
	@render 'signin'
	Session.set 'isChatting', false
