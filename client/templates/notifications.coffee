Template.notifications.helpers
	notifications: ->
		Notifications.find()

Template.notifications.onCreated ->
	Meteor.users.find
		'status.online': true
	.observeChanges
		added: (id, user) ->
			return if id is Meteor.userId()
			_addNotification
				type: 'default'
				header: "#{user.username}"
				message: 'is online!'
		removed: (id) ->
			return if id is Meteor.userId()
			_addNotification
				type: 'default'
				header: Meteor.users.findOne(id).username
				message: 'is offline...'

################################################################################
# _item
################################################################################
Template.notifications_item.events
	'click i.close': (event, template) ->
		_id = Template.currentData()._id
		$message = $ event.currentTarget
		.closest '.ui.message'
		template.dismissNotification $message, _id

Template.notifications_item.helpers
	isCustomize: ->
		Template.currentData().type is 'customized'

	messageClass: ->
		switch Template.currentData().type
			when 'default' then 'icon'
			when 'warning' then 'warning icon'
			when 'info' then 'info icon'
			when 'success' then 'positive icon'
			when 'error' then 'negative icon'
			when 'customized' then ''
			else ''

	iconClass: ->
		switch Template.currentData().type
			when 'default' then 'announcement'
			when 'warning' then 'warning sign'
			when 'info' then 'info circle'
			when 'success' then 'check square'
			when 'error' then 'bug'
			else ''

Template.notifications_item.onCreated ->
	@dismissNotification = ($message, _id) ->
		$message.transition 'fade up'

Template.notifications_item.onRendered ->
	return if (time = @data.dismissAfter) is 0

	time = if _.isNumber(time) and time > 0
	then time
	else NOTIFICATION_DISMISS_TIME

	$message = @$ '.message'
	Meteor.setTimeout =>
		@dismissNotification $message, @data._id
	, time

Template.notifications_item.onDestroyed ->
	_removeAllNotifications()
