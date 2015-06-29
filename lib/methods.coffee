Meteor.methods
	'addChannel': (channel) ->
		check channel, String
		if Channels.find(name: channel).count() > 0
			throw new Meteor.Error 'add-channel-failed', "Channel: #{channel} already exists."

		Channels.insert
			name: channel
			createdAt: new Date()

	'addMessage': (channel, text) ->
		check channel, String
		check text, String
		if Channels.find(name: channel).count() is 0
			throw new Meteor.Error 'add-message-failed', "Cannot find channel: #{channel}."

		Messages.insert
			avatar: 'steve'
			channel: channel
			createdAt: new Date()
			text: text
			username: 'zill'
