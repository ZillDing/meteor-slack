################################################################################
# config
################################################################################
Router.configure
	layoutTemplate: 'layout'
	notFoundTemplate: 'notFound'

Router.plugin 'ensureSignedIn',
	only: ['direct']


################################################################################
# routes
################################################################################
Router.route '/', ->
	@redirect '/channel/general'

Router.route '/channel/:_channel', ->
	channel = @params._channel
	@render 'messages',
		data:
			type: 'channel'
			target: channel
,
	name: 'channel'

Router.route '/direct/:_username', ->
	username = @params._username
	@render 'messages',
		data:
			type: 'direct'
			target: username
,
	name: 'direct'

Router.route '/profile', ->
	@render 'profile'
,
	name: 'profile'
