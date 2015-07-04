Template.input.events
	'submit form.form': (event) ->
		text = Template.instance().$('input').val()
		if text and channel = Session.get 'currentChannel'
			Meteor.call 'addMessage', channel, text, (error, result) ->
				if error
					Session.set 'error', error
				else
					# clear the form
					Template.instance().$('input').val ''
		# prevent default form submit
		false

Template.input.onRendered ->
	@autorun =>
		# focus on the input whenever channel changes
		Session.get 'currentChannel'
		@$('input').focus()
