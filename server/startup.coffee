Meteor.startup ->
	if Channels.find().count() is 0
		Channels.insert
			createdAt: new Date()
			name: 'general'

# add default profile when a new user signs up
Accounts.onCreateUser (options, user) ->
	user.profile = _.extend
		avatar: 'default.jpg'
		status: 'Yo! Sup!'
	, options.profile

	channelArray = Channels.find().map (channel) ->
		id: channel._id
		name: channel.name
		unread: 0
	UserData.insert
		owner: user._id
		data:
			channel: channelArray
			direct: []

	# return the user
	user

# watch for channels add
initializing = true
Channels.find().observeChanges
	added: (id, channel) ->
		if not initializing
			UserData.update {},
				$push:
					'data.channel':
						id: id
						name: channel.name
						unread: 0
			,
				multi: true

initializing = false
