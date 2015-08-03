Template.spotlight.onRendered ->
	$input = @$ 'input'

	@$('.ui.modal').modal
		duration: 0
		onShow: ->
			__keyListener.stop_listening()
		onVisible: ->
			# FIXME
			# cannot use $input.focus() since it does not work
			Meteor.setTimeout ->
				$input.focus()
			, 0
		onHidden: ->
			__keyListener.listen()
