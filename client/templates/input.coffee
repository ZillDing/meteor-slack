shiftKeyDown = false

Template.input.events
	'submit form.form': (event, template) ->
		isValid = (text) ->
			# make sure the text is not empty
			not _.isEmpty text.trim().replace '\n', ''

		$input = template.$ 'textarea'

		text = $input.val()
		type = Session.get 'chatType'
		target = Session.get 'chatTarget'
		if isValid(text) and type and target
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


Template.input.helpers
	settings: ->
		rules = []
		# only initiate autocomplete in channel chat
		if Session.equals 'chatType', 'channel'
			# only allow mentioning users in current channel
			array = Channels.findOne(name: Session.get 'chatTarget')?.usersId
			# remove the current user
			array = _.reject array, (id) ->
				id is Meteor.userId()
			rules.push
				token: '@'
				collection: Meteor.users
				field: 'username'
				filter:
					_id:
						$in: array
				template: Template.input_user

		position: 'top'
		limit: 5
		rules: rules


Template.input.onRendered ->
	if __deviceIsHoverable
		@$('i.send.icon').popup()

	@$('textarea').autosize()
	@autorun =>
		# focus on the input whenever target changes
		@$('textarea').focus() if Session.get 'chatTarget'
