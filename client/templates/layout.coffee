Template.layout.helpers
	mainStyle: ->
		if Session.get 'isChatting'
			'padding-top: 2.5rem; padding-bottom: 3.5rem'
		else
			'padding: 1rem'

Template.layout.onRendered ->
	@$('.sidebar').sidebar()
