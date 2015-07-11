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
	# create the userData and store the id
	# to user data
	channelArray = Channels.find().map (channel) ->
		id: channel._id
		name: channel.name
		unread: 0
	dataId = UserData.insert
		channel: channelArray
		direct: []
	user.dataId = dataId
	# return the user
	user

# watch for channels add
initializing = true
Channels.find().observeChanges
	added: (id, channel) ->
		if not initializing
			UserData.update {},
				$push:
					channel:
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
						channel:
							$elemMatch:
								id: message.target
					,
						$inc:
							'channel.$.unread': 1
					,
						multi: true
				when 'direct'
					# update only the receiver data
					senderId = message.owner
					receiverId = message.target
					# check the target direct chat list
					dataId = Meteor.users.findOne(receiverId).dataId
					chatArray = UserData.findOne(dataId).direct
					chatItem = _.find chatArray, (o) ->
						o.id is senderId
					if chatItem
						# the target has chat with sender
						# remove the old item in the db
						UserData.update dataId,
							$pull:
								direct:
									id: senderId
						# calculate the new unread number
						chatItem.unread++
						# add new chat item to the end of array
						UserData.update dataId,
							$push:
								direct: chatItem

					else
						# the target does not have chat with sender
						# add to the chat data
						UserData.update dataId,
							$push:
								direct:
									id: senderId
									name: message.username
									unread: 1

initializing = false
