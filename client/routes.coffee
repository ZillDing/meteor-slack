################################################################################
# config
################################################################################
Router.configure
	layoutTemplate: 'layout'
	notFoundTemplate: 'notfound'

Router.plugin 'ensureSignedIn',
	only: ['config', 'direct']


################################################################################
# routes
################################################################################
getSubs = ->
	result = []
	result.push Meteor.subscribe 'activities'
	result.push Meteor.subscribe 'allUsers'
	result.push Meteor.subscribe 'channels'
	result.push Meteor.subscribe 'currentUser' if Meteor.userId()
	result


Router.route '/', ->
	@redirect '/signin'


Router.route '/channel/:_channel',
	waitOn: getSubs
	action: ->
		channel = @params._channel
		@render 'messages',
			data:
				type: 'channel'
				target: channel


Router.route '/config',
	name: 'config'
	waitOn: getSubs
	action: ->
		Session.set 'showUtility', false
		@render 'config'


Router.route '/direct/:_username',
	name: 'direct'
	waitOn: getSubs
	action: ->
		username = @params._username
		if username is Meteor.user().username
			@redirect '/profile'
		else
			@render 'messages',
				data:
					type: 'direct'
					target: username


Router.route '/profile',
	waitOn: getSubs
	action: ->
		Session.set 'showUtility', false
		@render 'profile'


Router.route '/signin',
	waitOn: getSubs
	action: ->
		Session.set 'showUtility', false
		if Meteor.userId()
			@redirect '/profile'
		else
			@render 'signin'
