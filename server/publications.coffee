Meteor.publish 'channels', ->
	Channels.find()

Meteor.publish 'messages', ->
	Messages.find()

Meteor.publish 'messagesInChannel', (channelId) ->
	check channelId, String
	Messages.find
		channelId: channelId
