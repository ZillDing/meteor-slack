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
			throw new Meteor.Error error, "Channel: #{channel} already exists."

		Channels.insert
			createdAt: new Date()
			name: channel
			owner: Meteor.userId()

	'addMessage': (channel, text) ->
		error = 'add-message-failed'

		_checkLoggedIn error
		check channel, String
		check text, String
		if Channels.find(name: channel).count() is 0
			throw new Meteor.Error error, "Cannot find channel: #{channel}."

		Messages.insert
			avatar: Meteor.user().profile?.avatar ? 'default'
			channel: channel
			createdAt: new Date()
			owner: Meteor.userId()
			text: text
			username: Meteor.user().username

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
