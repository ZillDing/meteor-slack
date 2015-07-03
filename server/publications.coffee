Meteor.publish 'allUsersData', ->
	Meteor.users.find {},
		fields:
			username: 1
			createdAt: 1
			profile: 1

Meteor.publish 'channels', ->
	Channels.find()

Meteor.publish 'messages', ->
	Messages.find()

Meteor.publish 'messagesInChannel', (channel) ->
	check channel, String
	Messages.find
		channel: channel

Meteor.publish 'userData', ->
	if @userId
		Meteor.users.find
			_id: @userId
		,
			fields:
				createdAt: 1
	else
		@ready()
