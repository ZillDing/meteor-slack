Template.messages.helpers
	messages: ->
		chatType = Session.get 'chatType'
		chatTarget = Session.get 'chatTarget'
		switch chatType
			when 'channel'
				ChannelMessages.find()
			when 'direct'
				DirectMessages.find()


Template.messages.onCreated ->
	@prevData = null
	@clearUnread = (data) ->
		Meteor.call 'clearUnread', data, (error, result) ->
			_addErrorNotification error if error
	isValid = (data) ->
		if not _.contains ['channel', 'direct'], data.type
			_addErrorNotification
				error: 'Error'
				message: "Invalid chat type: #{data.type}"
			return false
		switch data.type
			when 'channel'
				if not Channels.findOne(name: data.target)
					_addErrorNotification
						error: 'No such channel'
						message: "Could not find channel with name: #{data.target}"
					return false
			when 'direct'
				if not Meteor.users.findOne(username: data.target)
					_addErrorNotification
						error: 'No such user'
						message: "Could not find user with username: #{data.target}"
					return false
		true

	@autorun =>
		data = Template.currentData()
		return if not isValid data

		@subscribe "#{data.type}Messages", data.target
		Session.set
			chatType: data.type
			chatTarget: data.target

		return if not Meteor.userId()
		@clearUnread @prevData if @prevData
		@prevData = data
		if data.type is 'direct'
			# note: need to run in non-reactive mode
			Tracker.nonreactive ->
				Meteor.call 'addChat', data, (error, result) ->
					_addErrorNotification error if error


Template.messages.onRendered ->
	$scrollContent = @$ '.ui.comments'
	$scrollContainer = $scrollContent.parent()
	@$('.ui.comments').resize ->
		top = $scrollContent.height() - $scrollContent.children('.comment').last().outerHeight()
		$scrollContainer.animate
			scrollTop: top


Template.messages.onDestroyed ->
	@clearUnread @prevData if Meteor.userId() and @prevData
	Session.set
		chatType: null
		chatTarget: null
