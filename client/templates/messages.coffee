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
		Tracker.nonreactive ->
			Meteor.call 'clearUnread', data, (error, result) ->
				_sAlertError error if error

	isValid = (data) ->
		Tracker.nonreactive ->
			if not _.contains ['channel', 'direct'], data.type
				sAlert.error
					sAlertTitle: 'Error'
					message: "Invalid chat type: #{data.type}"
				return false
			switch data.type
				when 'channel'
					a = Channels.find().map (channel) ->
						channel.name
					if not _.contains a, data.target
						_sAlertError
							error: 'No such channel'
							message: "Could not find channel with name: #{data.target}"
						return false
				when 'direct'
					a = Meteor.users.find().map (user) ->
						user.username
					if not _.contains a, data.target
						_sAlertError
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
		# note: need to run in non-reactive mode
		Tracker.nonreactive ->
			Meteor.call 'addChat', data, (error, result) ->
				_sAlertError error if error


Template.messages.onRendered ->
	# scroll to the bottom
	$scrollContent = @$ '.ui.comments'
	$scrollContainer = $scrollContent.parent()

	prevHeight = $scrollContent.height()
	@$('.ui.comments').resize ->
		return if prevHeight is $scrollContent.height()
		# only scroll to bottom if the height changed
		top = $scrollContent.height() - $scrollContent.children('.comment').last().outerHeight()
		$scrollContainer.animate
			scrollTop: top
		, ->
			$scrollContent.children('.comment').last().find('.avatar').transition 'jiggle'
		prevHeight = $scrollContent.height()

	# add key listener
	if Meteor.Device.isDesktop()
		# toggle utility side bar
		__keyListener.simple_combo 'shift u', ->
			Session.set 'showUtility', not Session.get 'showUtility'
		# toggle favourite chat
		data =
			type: Session.get 'chatType'
			target: Session.get 'chatTarget'
		__keyListener.simple_combo 'shift f', ->
			Meteor.call 'toggleFavourite', data, (error, result) ->
				_sAlertError error if error
		# delete current chat
		__keyListener.simple_combo 'shift d', ->
			$('.ui.modal.title-modal').modal 'show'


Template.messages.onDestroyed ->
	@clearUnread @prevData if Meteor.userId() and @prevData
	Session.set
		chatType: null
		chatTarget: null

	if Meteor.Device.isDesktop()
		__keyListener.unregister_combo 'shift u'
		__keyListener.unregister_combo 'shift f'
		__keyListener.unregister_combo 'shift d'


################################################################################
# _item
################################################################################
Template.messages_item.helpers
	message_html: ->
		message = Template.currentData()
		result = message.text
		# replace mentioned user
		result = result.replace /@(\w+)(\s|$)/g, (match, p1, p2) ->
			if _.contains message.mention?.user, Meteor.users.findOne(username: p1)?._id
				# this is a valid username
				"<a href=\"/direct/#{p1}\">@#{p1}</a>#{p2}"
			else
				match
		# replace mentioned channel
		result = result.replace /#(\w+)(\s|$)/g, (match, p1, p2) ->
			if _.contains message.mention?.channel, Channels.findOne(name: p1)?._id
				# this is a valid username
				"<a href=\"/channel/#{p1}\">##{p1}</a>#{p2}"
			else
				match
		result
