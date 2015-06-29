Meteor.publish 'channels', ->
	Channels.find()

Meteor.publish 'messages', ->
	Messages.find()

Meteor.publish 'messagesInChannel', (channel) ->
	check channel, String
	Messages.find
		channel: channel
