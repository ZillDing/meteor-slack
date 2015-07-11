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
getSubs = ->
	result = []
	result.push Meteor.subscribe 'allUsers'
	result.push Meteor.subscribe 'channels'
	result.push Meteor.subscribe 'currentUser' if Meteor.userId()
	result

Router.route '/', ->
	@redirect '/channel/general'

Router.route '/channel/:_channel',
	waitOn: getSubs
	action: ->
		channel = @params._channel
		@render 'messages',
			data:
				type: 'channel'
				target: channel

Router.route '/direct/:_username',
	name: 'direct'
	waitOn: getSubs
	action: ->
		username = @params._username
		@render 'messages',
			data:
				type: 'direct'
				target: username

Router.route '/profile',
	waitOn: getSubs
	action: ->
		@render 'profile'

Router.route '/signin',
	waitOn: getSubs
	action: ->
		@render 'signin'
