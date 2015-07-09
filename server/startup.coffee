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

Messages.find().observeChanges
	added: (id, message) ->
		if not initializing
			switch message.type
				when 'channel'
					# update all users chat data
					# increment the unread count of the channel by 1
					UserData.update
						'data.channel':
							$elemMatch:
								id: message.target
					,
						$inc:
							'data.channel.$.unread': 1
					,
						multi: true
				when 'direct'
					# update only the receiver data
					senderId = message.owner
					receiverId = message.target
					# check the target direct chat list
					userData = UserData.findOne
						owner: receiverId
						'data.direct':
							$elemMatch:
								id: senderId
					if userData
						# the target has chat with sender
						# calculate the new unread number
						chatArray = userData.data.direct
						chatItem = _.find chatArray, (o) ->
							o.id is senderId
						# remove the old item in the db
						UserData.update
							owner: receiverId
						,
							$pull:
								'data.direct':
									id: senderId
						chatItem.unread++
						UserData.update
							owner: receiverId
						,
							$push:
								'data.direct': chatItem

					else
						# the target does not have chat with sender
						UserData.update
							owner: receiverId
						,
							$push:
								'data.direct':
									id: senderId
									username: message.username
									unread: 1

initializing = false
