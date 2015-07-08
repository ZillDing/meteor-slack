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
		unread: 0
	user.chatData =
		channel: channelArray
		direct: []

	# return the user
	user
