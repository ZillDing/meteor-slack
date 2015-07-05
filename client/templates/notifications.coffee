Template.notifications.helpers
	notifications: ->
		Notifications.find()

################################################################################
# _item
################################################################################
Template.notifications_item.events
	'click i.close': (event) ->
		# dismiss the error message
		_id = Template.currentData()._id
		$ event.currentTarget
		.closest '.ui.message'
		.transition 'fade up', ->
			_removeNotification _id

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
