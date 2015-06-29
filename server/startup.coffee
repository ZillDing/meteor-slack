Meteor.startup ->
	if Channels.find().count() is 0
		Meteor.call 'addChannel', 'general'
