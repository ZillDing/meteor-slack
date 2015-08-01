Template.input.events
	'submit form.form': (event, template) ->
		isValid = (text) ->
			# make sure the text is not empty
			not _.isEmpty text.trim().replace '\n', ''
		getValidMention = (text) ->
			aC = _.filter template.mention.channel, (channelId) ->
				_isValidChannelMention channelId, text
			aU = _.filter template.mention.user, (userId) ->
				_isValidUserMention userId, text
			# return the mention object
			channel: aC
			user: aU

		$input = template.$ 'textarea'

		text = $input.val().trim()
		type = Session.get 'chatType'
		target = Session.get 'chatTarget'
		if isValid(text) and type and target
			message =
				type: type
				target: target
				text: text
				mention: getValidMention(text)
			Meteor.call 'addMessage', message, (error, result) ->
				if error
					sAlertError error
				else
					# clear the form
					$input.val('').trigger 'autosize.resize'
					# clear mention
					template.mention =
						channel: []
						user: []
		# prevent default form submit
		false

	'click i.send.icon': (event, template) ->
		template.$('form.form').submit()

	'autocompleteselect textarea': (event, template, doc) ->
		mention = template.mention
		if doc.username
			mention.user.push doc._id if not _.contains mention.user, doc._id
		else
			mention.channel.push doc._id if not _.contains mention.channel, doc._id

	'focus textarea': (event) ->
		__keyListener.stop_listening() if Meteor.Device.isDesktop()

	'blur textarea': (event) ->
		__keyListener.listen() if Meteor.Device.isDesktop()


Template.input.helpers
	settings: ->
		rules = []
		# allow mention channel in any chat
		# only allow mention channels that current user is in
		channelIdArray = _.map Meteor.user()?.data()?.channel, (o) ->
			o.id
		rules.push
			token: '#'
			collection: Channels
			field: 'name'
			filter:
				_id:
					$in: channelIdArray
			template: Template.input_channel

		# allow mention user in channel chat
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


Template.input.onCreated ->
	@mention =
		channel: []
		user: []


Template.input.onRendered ->
	# set up send button popup
	@$('i.send.icon').popup() if __deviceIsHoverable

	$textarea = @$ 'textarea'

	if Meteor.Device.isDesktop()
		# create key listener to listen to enter key
		@keyListener = new window.keypress.Listener $textarea[0]
		# press meta + enter to submit the form
		@keyListener.simple_combo 'meta enter', =>
			@$('form.form').submit()
		# press esc to blur the input
		@keyListener.simple_combo 'esc', ->
			$textarea.blur()

		# add key listener to focus on textarea
		__keyListener.simple_combo 'shift i', ->
			$textarea.focus()

	# set up textarea
	$textarea.autosize()
	@autorun ->
		# focus on the input whenever target changes
		$textarea.focus() if Session.get 'chatTarget'


Template.input.onDestroyed ->
	if Meteor.Device.isDesktop()
		@keyListener.destroy()
		__keyListener.unregister_combo 'shift i'
