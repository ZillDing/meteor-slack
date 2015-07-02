Template.error.events
	'click i': (event) ->
		# dismiss the error message
		$ event.currentTarget
		.closest '.ui.message'
		.transition 'fade up', ->
			Session.set 'error', null

Template.error.helpers
	error: ->
		Session.get 'error'
