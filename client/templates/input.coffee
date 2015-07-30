shiftKeyDown = false

Template.input.events
	'submit form.form': (event, template) ->
		$input = template.$ 'textarea'

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
					sAlertError error
				else
					# clear the form
					$input.val('').trigger 'autosize.resize'
		# prevent default form submit
		false

	'keydown textarea': (event, template) ->
		if event.which is 16
			shiftKeyDown = true

	'keyup textarea': (event, template) ->
		if event.which is 16
			shiftKeyDown = false
		if event.which is 13 and not shiftKeyDown
			# submit the form
			template.$('form.form').submit()

	'click i.send.icon': (event, template) ->
		template.$('form.form').submit()

Template.input.onRendered ->
	if __deviceIsHoverable
		@$('i.send.icon').popup()

	@$('textarea').autosize()
	@autorun =>
		# focus on the input whenever target changes
		@$('textarea').focus() if Session.get 'chatTarget'
