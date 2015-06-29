_dismissError = (dom) ->
	$(dom).fadeOut ->
		Session.set 'error', null

Template.error.events
	'click i': (event) ->
		_dismissError $(event.currentTarget).closest '.ui.message'

Template.error.helpers
	error: ->
		Session.get 'error'
