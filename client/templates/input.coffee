Template.input.events
	'submit form.form': (event) ->
		text = event.target.text.value
		if text and channel = Session.get 'currentChannel'
			Meteor.call 'addMessage', channel, text, (error, result) ->
				if error
					Session.set 'error', error
				else
					# clear the form
					event.target.text.value = ''
		# prevent default form submit
		false

Template.input.onRendered ->
	@autorun =>
		# focus on the input whenever channel changes
		Session.get 'currentChannel'
		@$('input').focus()
