Template.error.events
	'click i': ->
		Session.set 'error', null

Template.error.helpers
	hasError: ->
		if Session.get 'error'
			true
		else
			false

	error: ->
		Session.get 'error'
