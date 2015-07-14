Template.notifications.helpers
	notifications: ->
		Notifications.find {},
			sort: createdAt: -1

Template.notifications.onCreated ->

	Meteor.users.find
		'status.online': true
	.observeChanges
		added: (id, user) ->
			return if id is Meteor.userId()
			_addNotification
				type: 'customized'
				templateName: 'notifications_item_user'
				user: user
				message: 'is online!'
				dismissAfter: 0
		removed: (id) ->
			return if id is Meteor.userId()
			_addNotification
				type: 'customized'
				templateName: 'notifications_item_user'
				user: Meteor.users.findOne id
				message: 'is offline...'
				dismissAfter: 0

	Channels.find().observeChanges
		added: (id, channel) ->
			return if channel.name is 'general'
			_addNotification
				type: 'customized'
				templateName: 'notifications_item_user'
				user: Channels.findOne(id).owner()
				message: "created a new channel: #{channel.name}"
				dismissAfter: 0

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
	messageClass: ->
		switch Template.currentData().type
			when 'default' then 'icon'
			when 'warning' then 'warning icon'
			when 'info' then 'info icon'
			when 'success' then 'positive icon'
			when 'error' then 'negative icon'
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
	$message.transition 'tada'
	Meteor.setTimeout =>
		@dismissNotification $message, @data._id
	, time

Template.notifications_item.onDestroyed ->
	_removeAllNotifications()
