Template.input.events
	'keypress input': (event) ->
		if event.which is 13
			text = event.currentTarget.value.trim()
			if text and Session.get 'currentChannel'
				channel = Session.get 'currentChannel'
				Meteor.call 'addMessage', channel, text, (error, result) ->
					if error
						Session.set 'error', error
					else
						# clear the form
						event.currentTarget.value = ''

Template.input.onRendered ->
	@autorun =>
		# focus on the input whenever channel changes
		Session.get 'currentChannel'
		@$('input').focus()
