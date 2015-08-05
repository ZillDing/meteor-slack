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

# note: the following userId has no value.
# to get the user id, use 'user._id'
Meteor.users.after.insert (userId, user) ->
	# add the user id to all channels' usersId
	Channels.update {},
		$push:
			usersId: user._id
	,
		multi: true

	# add to notifications
	Notifications.insert
		ownerId: user._id
		type: 'new-user'

Meteor.users.after.update (userId, user, fieldNames, modifier, options) ->
	if @previous.status?.online isnt user.status?.online
		Notifications.insert
			ownerId: user._id
			type: 'user-status'


################################################################################
# for other collections
################################################################################
# Channels
Channels.before.insert (userId, channel) ->
	# add current all users id
	channel.usersId = Meteor.users.find().map (user) ->
		user._id

Channels.after.insert (userId, channel) ->
	# insert into all users' data
	UserData.update {},
		$push:
			channel:
				id: channel._id
				unread: 0
	,
		multi: true

	# add to notifications
	Notifications.insert
		channelId: channel._id
		ownerId: userId
		type: 'new-channel'


# ChannelMessages
ChannelMessages.after.insert (userId, message) ->
	# update only mentioned users' chat data
	# increment the unread count of the channel by 1
	_.each message.mention.user, (userId) ->
		if __M_S.f_isValidUserMention userId, message.text
			UserData.update
				_id: Meteor.users.findOne(userId).dataId
				channel:
					$elemMatch:
						id: message.channelId
			,
				$inc:
					'channel.$.unread': 1
			,
				multi: true

			# add to notifications
			Notifications.insert
				channelId: message.channelId
				ownerId: message.ownerId
				targetId: userId
				type: 'channel-mention'


# DirectMessages
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

	# add to notifications
	Notifications.insert
		ownerId: senderId
		targetId: receiverId
		type: 'direct-message'


# Notifications
Notifications.before.insert (userId, notification) ->
	o = @transform()
	notification.ownerName = o.owner().username
	notification.ownerStatus = o.owner().status if notification.type is 'user-status'

	notification.channelName = o.channel().name if notification.channelId
	notification.targetName = o.target().username if notification.targetId

Notifications.after.insert (userId, notification) ->
	# selectively create activity
	switch notification.type
		when 'new-user'
			Activities.insert
				ownerId: notification.ownerId
				type: 'new-user'
		when 'new-channel'
			Activities.insert
				channelId: notification.channelId
				ownerId: notification.ownerId
				type: 'new-channel'

	# self destructive
	# remove this notification after 3 seconds
	Meteor.setTimeout ->
		Notifications.remove notification._id
	, 3000


# Activities
Activities.before.insert (userId, activity) ->
	activity.createdAt = Date.now()
