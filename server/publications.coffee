# all channels infomation
Meteor.publish 'channels', ->
	Channels.find()

# messages that is either:
#   channel messages: messages from specific channel
#   direct messages:  messages between two users
Meteor.publish 'targetedMessages', (data) ->
	check data,
		type: Match.OneOf 'channel', 'direct'
		target: String

	result = switch data.type
		when 'channel'
			channelId = Channels.findOne(name: data.target)._id
			Messages.find
				type: 'channel'
				target: channelId
		when 'direct'
			userId = Meteor.users.findOne(username: data.target)._id
			Messages.find
				$or: [
					type: 'direct'
					owner: @userId
					target: userId
				,
					type: 'direct'
					owner: userId
					target: @userId
				]
		else undefined
	result

# user infomation
Meteor.publish 'currentUser', ->
	[
		Meteor.users.find
			_id: @userId
		,
			fields:
				createdAt: 1
				status: 1
	,
		UserData.find
			owner: @userId
	]

Meteor.publish 'allUsers', ->
	Meteor.users.find {},
		fields:
			username: 1
			createdAt: 1
			profile: 1
			status: 1
