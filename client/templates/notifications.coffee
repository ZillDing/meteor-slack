Template.notifications.events
	'click i': (event) ->
		# dismiss the error message
		$ event.currentTarget
		.closest '.ui.message'
		.transition 'fade up', ->
			Session.set 'error', null

Template.notifications.helpers
	notification: ->
		Session.get 'error'
