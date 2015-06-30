Router.configure
	layoutTemplate: 'layout'

Router.route '/', ->
	@render 'messages',
		data:
			channel: 'general'

Router.route '/signin', ->
	@render 'signin'
	Session.set 'currentChannel', null

# Router.route '/signout', ->
# 	Meteor.logout()
# 	@redirect '/'

Router.route '/channel/:_channel', ->
	channel = @params._channel
	@render 'messages',
		data:
			channel: channel
