Template.layout.helpers
	mainStyle: ->
		if Session.get 'isChatting'
			'padding-top: 3.5rem; padding-bottom: 4.5rem'
		else
			'padding: 1rem'
