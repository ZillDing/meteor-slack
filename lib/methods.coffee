# note: meteor coffeescript too old to support string interpolation in object key

# check whether the user logged in or not
# throw an error if not
_checkLoggedIn = (error) ->
	if not Meteor.userId()
		throw new Meteor.Error error, 'Not authorized. Please sign in first.'
# get the target id based on data type and name (either a channel name or username)
# the returned value is either an id of a channel or a user
_getTargetId = (data, error) ->
	targetId = switch data.type
		when 'channel' then Channels.findOne(name: data.target)?._id
		when 'direct' then Meteor.users.findOne(username: data.target)?._id
	if not targetId
		throw new Meteor.Error error, "Could not find target type #{data.type} with name: #{data.target}"
	targetId
################################################################################
# end of private methods
################################################################################

Meteor.methods
	# add a chat to user's data
	# either a channel or a direct chat
	# the added channel or user will show in the sidebar as well as title
	addChat: (data) ->
		error = 'Add chat failed'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		targetId = _getTargetId data, error

		array = Meteor.user().data()[data.type]
		item = _.find array, (o) ->
			o.id is targetId
		if not item
			# if the chat target is not in current user data
			# if chat type is channel, update channel data
			if data.type is 'channel'
				Channels.update targetId,
					$push:
						usersId: Meteor.userId()
			# add to user data
			UserData.update Meteor.user().dataId,
				$push:
					"#{data.type}":
						id: targetId
						unread: 0

	addMessage: (message) ->
		error = 'Add message failed'

		# validation
		_checkLoggedIn error
		check message, Match.ObjectIncluding
			type: Match.OneOf 'channel', 'direct'
			target: String
			text: String
			mention:
				channel: [String]
				user: [String]
		targetId = _getTargetId message, error

		# add the new message into corresponding db collection
		newMessage =
			mention: message.mention
			ownerId: Meteor.userId()
			text: message.text

		if message.type is 'channel'
			newMessage.channelId = targetId
			ChannelMessages.insert newMessage

		if message.type is 'direct'
			newMessage.targetId = targetId
			DirectMessages.insert newMessage

	# clear unread count of a specific chat
	# this will also clear the 'highlight' field if this is a channel chat
	clearUnread: (data) ->
		error = 'Clear unread error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		o = {}
		o["#{data.type}.$.unread"] = 0
		o["#{data.type}.$.highlight"] = false if data.type is 'channel'
		UserData.update
			_id: Meteor.user().dataId
			"#{data.type}.id": _getTargetId data, error
		,
			$set: o

	# create a new channel in the system
	# for every one
	createChannel: (channel) ->
		error = 'Create channel failed'

		_checkLoggedIn error
		check channel, String
		channel = channel.toLowerCase().trim()
		if /\W/.test channel
			throw new Meteor.Error error, "Invalid channel name: #{channel}. Alphanumeric character (including _) only."
		# prevent channel duplication
		if Channels.findOne(name: channel)
			throw new Meteor.Error error, "Duplicate channel name: #{channel}"

		Channels.insert
			name: channel
			ownerId: Meteor.userId()

	# delete the owner's chat data
	# either quit channel or
	# delete a direct chat
	# note: this will not delete the channel in the system
	# or delete the direct chat messages
	removeChat: (data) ->
		error = 'Remove chat error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		targetId = _getTargetId data, error
		# if the chat type is channel
		# update channel data
		if data.type is 'channel'
			Channels.update targetId,
				$pull:
					usersId: Meteor.userId()

		UserData.update Meteor.user().dataId,
			$pull:
				"#{data.type}":
					id: targetId

	toggleFavourite: (data) ->
		error = 'Toggle favourite error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String
		targetId = _getTargetId data, error

		array = Meteor.user().data()[data.type]
		item = _.find array, (o) ->
			o.id is targetId
		newFavourite = not item.favourite

		UserData.update
			_id: Meteor.user().dataId
			"#{data.type}.id": targetId
		,
			$set:
				"#{data.type}.$.favourite": newFavourite

	updateUserProfile: (profile) ->
		error = 'update-user-profile-failed'

		_checkLoggedIn error
		check profile,
			avatar: String
			status: String

		Meteor.users.update Meteor.userId(),
			$set:
				'profile.avatar': profile.avatar
				'profile.status': profile.status
