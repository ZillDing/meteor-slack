Meteor.startup ->
	if Channels.find().count() is 0
		Channels.insert
			createdAt: new Date()
			name: 'general'
			usersId: Meteor.users.find().map (user) ->
				user._id
