_checkLoggedIn = (error) ->
	if not Meteor.userId()
		throw new Meteor.Error error, 'Not authorized. Please sign in first.'

Meteor.methods
	'addChannel': (channel) ->
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

	'addMessage': (message) ->
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
			avatar: Meteor.user().profile?.avatar ? 'default'
			createdAt: new Date()
			owner: Meteor.userId()
			username: Meteor.user().username
		, message

	'updateUserProfile': (profile) ->
		error = 'update-user-profile-failed'

		_checkLoggedIn error
		check profile,
			avatar: String
			status: String

		Meteor.users.update Meteor.userId(),
			$set:
				'profile.avatar': profile.avatar
				'profile.status': profile.status
