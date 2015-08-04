################################################################################
# config
################################################################################
Router.configure
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
	result.push Meteor.subscribe 'currentUser'
	result.push Meteor.subscribe 'notifications'
	result


Router.route '/', ->
	@redirect '/signin'


Router.route '/channel/:_channel',
	layoutTemplate: 'layout'
	waitOn: getSubs
	action: ->
		channel = @params._channel
		@render 'messages',
			data:
				type: 'channel'
				target: channel


Router.route '/config',
	layoutTemplate: 'layout'
	name: 'config'
	waitOn: getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		@render 'config'


Router.route '/direct/:_username',
	layoutTemplate: 'layout'
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


Router.route '/help',
	layoutTemplate: 'layout'
	waitOn: getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		@render 'help'


Router.route '/profile',
	layoutTemplate: 'layout'
	waitOn: getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		@render 'profile'


Router.route '/signin',
	layoutTemplate: 'layout'
	waitOn: getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		if Meteor.userId()
			@redirect '/profile'
		else
			@render 'signin'
