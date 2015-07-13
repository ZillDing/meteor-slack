################################################################################
# for built-in Meteor.users collection
################################################################################
# note: the userId is undefined in the following three hooks
Meteor.users.before.insert (userId, user) ->
	# create the userData and store the id
	# to user data
	channelArray = Channels.find().map (channel) ->
		id: channel._id
		unread: 0
	dataId = UserData.insert
		channel: channelArray
		direct: []
	user.dataId = dataId

# add default profile when a new user signs up
# note: this is provided by native meteor package
Accounts.onCreateUser (options, user) ->
	user.profile = _.extend
		avatar: 'default.jpg'
		status: 'Yo! Sup!'
	, options.profile
	# return the user
	user

Meteor.users.after.insert (userId, user) ->
	# add the user id to all channels' usersId
	Channels.update {},
		$push:
			usersId: user._id
	,
		multi: true


################################################################################
# for other collections
################################################################################
Channels.before.insert (userId, channel) ->
	# add current all users id
	channel.usersId = Meteor.users.find().map (user) ->
		user._id

Channels.after.insert (userId, channel) ->
	# insert into all users' data
	UserData.update {},
		$push:
			channel:
				id: @_id
				unread: 0
	,
		multi: true


ChannelMessages.after.insert (userId, message) ->
	# update all users chat data
	# increment the unread count of the channel by 1
	UserData.update
		channel:
			$elemMatch:
				id: message.channelId
	,
		$inc:
			'channel.$.unread': 1
	,
		multi: true


DirectMessages.after.insert (userId, message) ->
	# update only the receiver data
	senderId = message.ownerId
	receiverId = message.targetId
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
					unread: 1
