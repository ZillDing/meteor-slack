@_isValidUserMention = (userId, text) ->
	username = Meteor.users.findOne(userId)?.username
	return false if _.isEmpty username

	re = new RegExp "@#{username}(\\s|$)"
	re.test text

@_isValidChannelMention = (channelId, text) ->
	name = Channels.findOne(channelId)?.name
	return false if _.isEmpty name

	re = new RegExp "##{name}(\\s|$)"
	re.test text
