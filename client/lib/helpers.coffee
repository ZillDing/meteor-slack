################################################################################
# utils
################################################################################
String.prototype.capitalize = ->
	@charAt(0).toUpperCase() + @substring 1

################################################################################
# CONSTANTS
################################################################################
Template.registerHelper 'BRAND_NAME', ->
	'TAISS'

Template.registerHelper 'LARGE_AVATAR_DIR', ->
	'/images/avatar/large'

Template.registerHelper 'SMALL_AVATAR_DIR', ->
	'/images/avatar/small'

################################################################################
# variables
################################################################################
Template.registerHelper '__isChatting', ->
	Session.get 'isChatting'

################################################################################
# functions
################################################################################
Template.registerHelper '_getJoinTime', (date) ->
	moment(date).format 'YYYY, MMM'

Template.registerHelper '_getUserProfileAvatar', (profile) ->
	return 'default' if _.isEmpty profile?.avatar
	return 'default' if not _.isString profile?.avatar
	profile.avatar

Template.registerHelper '_getUserProfileStatus', (profile) ->
	return 'online' if _.isEmpty profile?.status
	return 'online' if not _.isString profile?.status
	profile.status


################################################################################
# notifications
################################################################################
@Notifications = new Mongo.Collection null

@_addNotification = (notification) ->
	check notification,
		type: Match.OneOf 'default', 'success', 'error', 'info', 'warning', 'customized'
		header: String
		message: String
		html: Match.Optional String
		dismissAfter: Match.Optional Match.Integer

	Notifications.insert notification

@_removeAllNotifications = ->
	Notifications.remove {}

@_removeNotification = (_id) ->
	check _id, String
	Notifications.remove _id
