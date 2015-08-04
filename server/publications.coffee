# all channels infomation
Meteor.publish 'channels', ->
	Channels.find()

# user infomation
Meteor.publish 'currentUser', ->
	dataId = Meteor.users.findOne(@userId)?.dataId
	[
		Meteor.users.find
			_id: @userId
		,
			fields:
				dataId: 1
	,
		UserData.find dataId
	]

Meteor.publish 'allUsers', ->
	Meteor.users.find {},
		fields:
			username: 1
			createdAt: 1
			profile: 1
			status: 1

# messages
Meteor.publish 'channelMessages', (name) ->
	channelId = Channels.findOne(name: name)?._id
	ChannelMessages.find
		channelId: channelId

Meteor.publish 'directMessages', (username) ->
	userId = Meteor.users.findOne(username: username)?._id
	DirectMessages.find
		$or: [
			ownerId: @userId
			targetId: userId
		,
			ownerId: userId
			targetId: @userId
		]

# activities
Meteor.publish 'activities', ->
	Activities.find()

# notifications
Meteor.publish 'notifications', ->
	Notifications.find
		ownerId:
			$ne: @userId
		$or: [
			targetId:
				$exists: false
		,
			targetId: @userId
		]
