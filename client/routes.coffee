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
			type: 'channel'
			target: channel

Router.route '/direct/:_username', ->
	username = @params._username
	@render 'messages',
		data:
			type: 'direct'
			target: username

Router.route '/profile', ->
	@render 'profile'

Router.route '/signin', ->
	@render 'signin'
