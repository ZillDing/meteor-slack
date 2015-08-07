################################################################################
# config
################################################################################
Router.configure
	loadingTemplate: 'loading'
	notFoundTemplate: 'notfound'

	# router hooks
	onBeforeAction: ->
		$('.popup-trigger').popup 'hide'
		@next()


Router.plugin 'ensureSignedIn',
	only: ['config', 'direct']


################################################################################
# routes
################################################################################
_getSubs = ->
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
	waitOn: _getSubs
	action: ->
		channel = @params._channel
		@render 'messages',
			data:
				type: 'channel'
				target: channel


Router.route '/config',
	layoutTemplate: 'layout'
	name: 'config'
	waitOn: _getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		@render 'config'


Router.route '/direct/:_username',
	layoutTemplate: 'layout'
	name: 'direct'
	waitOn: _getSubs
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
	waitOn: _getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		@render 'help'


Router.route '/profile',
	layoutTemplate: 'layout'
	waitOn: _getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		@render 'profile'


Router.route '/signin',
	layoutTemplate: 'layout'
	waitOn: _getSubs
	action: ->
		Session.set '__M_S_showUtility', false
		if Meteor.userId()
			@redirect '/profile'
		else
			@render 'signin'
