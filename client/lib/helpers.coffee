################################################################################
# global variables
################################################################################
@__deviceIsHoverable = Meteor.Device.isTV() or Meteor.Device.isDesktop()


################################################################################
# Helpers for all templates
################################################################################
# CONSTANTS
Template.registerHelper 'BRAND_NAME', ->
	'TAISS'

Template.registerHelper 'LARGE_AVATAR_DIR', ->
	'/images/avatar/large'

Template.registerHelper 'SMALL_AVATAR_DIR', ->
	'/images/avatar/small'

# variables
Template.registerHelper '__isChatting', ->
	Session.get 'isChatting'

# functions
Template.registerHelper '_getItemClass', (type, target) ->
	return '' if not Session.get 'isChatting'
	return '' if not Session.equals 'chatType', type

	if Session.equals 'chatTarget', target
		'active'
	else
		''

Template.registerHelper '_getJoinTime', (date) ->
	moment(date).format 'YYYY, MMM'


################################################################################
# notifications
################################################################################
@Notifications = new Mongo.Collection null

@_addNotification = (notification) ->
	check notification,
		type: Match.OneOf 'default', 'success', 'error', 'info', 'warning', 'customized'
		header: Match.Optional String
		message: Match.Optional String
		html: Match.Optional String
		dismissAfter: Match.Optional Match.Integer

	Notifications.insert notification

@_addErrorNotification = (error) ->
	_addNotification
		type: 'error'
		header: error.error
		message: error.message

@_removeAllNotifications = ->
	Notifications.remove {}

@_removeNotification = (_id) ->
	check _id, String
	Notifications.remove _id
