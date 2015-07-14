################################################################################
# a client side universal notification center
################################################################################
@Notifications = new Mongo.Collection null

# default notification dismiss time
@NOTIFICATION_DISMISS_TIME = 4000

@_addNotification = (notification) ->
	check notification, Match.ObjectIncluding
		type: Match.OneOf 'default', 'success', 'error', 'info', 'warning', 'customized'
		header: Match.Optional Match.OneOf String, Number
		message: Match.Optional String
		templateName: Match.Optional String
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
