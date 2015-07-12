_checkLoggedIn = (error) ->
	if not Meteor.userId()
		throw new Meteor.Error error, 'Not authorized. Please sign in first.'

Meteor.methods
	# add a chat to user's data
	# either a channel or a direct chat
	# the added channel or user will show in the sidebar as well as title
	addChat: (data) ->
		error = 'add-chat-failed'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		targetId = switch data.type
			when 'channel' then targetId = Channels.findOne(name: data.target)?._id
			when 'direct' then targetId = Meteor.users.findOne(username: data.target)?._id
		if not targetId
			throw new Meteor.Error error, "Could not find target with name: #{data.target}"

		array = Meteor.user().data()[data.type]
		item = _.find array, (o) ->
			o.name is data.target
		o = {}
		o[data.type] =
			id: targetId
			name: data.target
			unread: 0
		if not item
			# if the chat target is not in current user data
			# add to user data
			UserData.update Meteor.user().dataId,
				$push: o

	addMessage: (message) ->
		error = 'add-message-failed'

		# validation
		_checkLoggedIn error
		check message, Match.ObjectIncluding
			type: Match.OneOf 'channel', 'direct'
			target: String
			text: String
		targetId = switch message.type
			when 'channel' then Channels.findOne(name: message.target)?._id
			when 'direct' then Meteor.users.findOne(username: message.target)?._id
		if not targetId
			throw new Meteor.Error error, "Cannot find target with name: #{message.target}."

		# add the new message into corresponding db collection
		newMessage =
			createdAt: new Date()
			ownerId: Meteor.userId()
			text: message.text

		if message.type is 'channel'
			newMessage.channelId = targetId
			ChannelMessages.insert newMessage

		if message.type is 'direct'
			newMessage.targetId = targetId
			DirectMessages.insert newMessage

	clearUnread: (data) ->
		error = 'clear-unread-error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		selector = {}
		selector['_id'] = Meteor.user().dataId
		selector["#{data.type}.name"] = data.target
		o = {}
		o["#{data.type}.$.unread"] = 0
		modifier =
			$set: o
		UserData.update selector, modifier

	# create a new channel in the system
	# for every one
	createChannel: (channel) ->
		error = 'create-channel-failed'

		_checkLoggedIn error
		check channel, String
		channel = channel.toLowerCase()
		if Channels.find(name: channel).count() > 0
			throw new Meteor.Error error, "Duplicate channel name: #{channel}"

		Channels.insert
			createdAt: new Date()
			name: channel
			ownerId: Meteor.userId()

	# delete the owner's chat data
	# either quit channel or
	# delete a direct chat
	# note: this will not delete the channel in the system
	# or delete the direct chat messages
	removeChat: (data) ->
		error = 'remove-chat-error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		o = {}
		o["#{data.type}"] =
			name: data.target
		UserData.update Meteor.user().dataId,
			$pull: o

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
