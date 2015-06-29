Router.configure
	layoutTemplate: 'layout'

Router.route '/', ->
	Session.set 'currentChannel', 'general'
	@next()

# Router.route '/signin', ->
# 	@render 'SignIn'

# Router.route '/signout', ->
# 	Meteor.logout()
# 	@redirect '/'

Router.route '/:_channel', ->
	Session.set 'currentChannel', @params._channel
	@next()
