_checkLoggedIn = (error) ->
	if not Meteor.userId()
		throw new Meteor.Error error, 'Not authorized. Please sign in first.'

Meteor.methods
	addChannel: (channel) ->
		error = 'add-channel-failed'

		_checkLoggedIn error
		check channel, String
		channel = channel.toLowerCase()
		if Channels.find(name: channel).count() > 0
			throw new Meteor.Error error, "Duplicate channel name: #{channel}"

		Channels.insert
			createdAt: new Date()
			name: channel
			owner: Meteor.userId()

	addMessage: (message) ->
		error = 'add-message-failed'

		_checkLoggedIn error
		check message, Match.ObjectIncluding
			type: Match.OneOf 'channel', 'direct'
			target: String
			text: String

		doc = null
		switch message.type
			when 'channel'
				if not doc = Channels.findOne(name: message.target)
					throw new Meteor.Error error, "Cannot find channel: #{message.target}."
			when 'direct'
				if not doc = Meteor.users.findOne(username: message.target)
					throw new Meteor.Error error, "Cannot find user: #{message.target}."
		# note: need to change the target to id instead of using name
		# to store in db
		message.target = doc._id

		Messages.insert _.extend
			avatar: Meteor.user().profile.avatar
			createdAt: new Date()
			owner: Meteor.userId()
			username: Meteor.user().username
		, message

	clearUnread: (data) ->
		error = 'clear-unread-error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		selector = {}
		selector['_id'] = Meteor.user().data
		selector["#{data.type}.name"] = data.target
		o = {}
		o["#{data.type}.$.unread"] = 0
		modifier =
			$set: o
		UserData.update selector, modifier

	# delete the owner's chat data
	# either quit channel or
	# delete a direct chat
	removeChat: (data) ->
		error = 'remove-chat-error'

		_checkLoggedIn error
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String

		o = {}
		o["#{data.type}"] =
			name: data.target
		UserData.update Meteor.user().data,
			$pull: o

	startDirectChat: (username) ->
		error = 'start-direct-chat-error'

		_checkLoggedIn error
		check username, String
		user = Meteor.users.findOne
			username: username
		if not user
			throw new Meteor.Error error, "Cannot find user with username: #{username}"

		chatArray = UserData.findOne(Meteor.user().data).direct
		item = _.find chatArray, (o) ->
			o.name is username
		if not item
			UserData.update Meteor.user().data,
				$push:
					direct:
						id: user._id
						name: username
						unread: 0

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
