Router.configure
	layoutTemplate: 'layout'

Router.route '/', ->
	@render 'messages',
		data: ->
			channel: 'general'

# Router.route '/signin', ->
# 	@render 'SignIn'

# Router.route '/signout', ->
# 	Meteor.logout()
# 	@redirect '/'

Router.route '/:_channel', ->
	@render 'messages',
		data: ->
			channel: @params._channel
