Meteor.publish 'allUsersData', ->
	Meteor.users.find {},
		fields:
			username: 1
			createdAt: 1
			profile: 1

Meteor.publish 'channels', ->
	Channels.find()

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
			userId = Meteor.users.find(username: data.target)._id
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

Meteor.publish 'userData', ->
	if @userId
		Meteor.users.find
			_id: @userId
		,
			fields:
				createdAt: 1
	else
		@ready()
