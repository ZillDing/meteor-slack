################################################################################
# a client side universal notification center
################################################################################
@Notifications = new Mongo.Collection null

# default notification dismiss time
@NOTIFICATION_DISMISS_TIME = 4000

@_addNotification = (notification) ->
	check notification,
		type: Match.OneOf 'default', 'success', 'error', 'info', 'warning', 'customized'
		header: Match.OneOf (Match.Optional String), Match.Optional Number
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
