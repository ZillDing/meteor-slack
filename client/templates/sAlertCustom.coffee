Template.sAlertCustom.events
	'click i.close.icon': (event) ->
		alertId = $(event.currentTarget).closest('.ui.message').attr 'id'
		sAlert.close alertId


Template.sAlertCustom.helpers
	sAlertIcon: ->
		switch Template.currentData().condition
			when 'warning' then 'warning sign'
			when 'info' then 'info circle'
			when 'success' then 'check square'
			when 'error' then 'bug'
			else 'announcement'
