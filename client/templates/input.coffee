Template.input.events
	'submit form.form': (event) ->
		$input = Template.instance().$ 'input'

		text = $input.val()
		type = Session.get 'chatType'
		target = Session.get 'chatTarget'
		if text and type and target
			message =
				type: type
				target: target
				text: text
			Meteor.call 'addMessage', message, (error, result) ->
				if error
					_addErrorNotification error
				else
					# clear the form
					$input.val ''
		# prevent default form submit
		false

Template.input.onRendered ->
	@autorun =>
		# focus on the input whenever target changes
		Session.get 'chatTarget'
		@$('input').focus()
