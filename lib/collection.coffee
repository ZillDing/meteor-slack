### user schema

_id: String
createdAt: Date
dataId: String
proflie:
	avatar: String
	status: String
status:
	idle: Boolean
	lastLogin:
		date: Date
		ipAddr: String
		userAgent: String
	online: Boolean
username: String

###


### channel schema

_id: String
createdAt: Date
name: String
ownerId: String

###
@Channels = new Mongo.Collection 'channels'


messagesHelpers =
	owner: ->
		Meteor.users.findOne @ownerId
### channelMessages schema

_id: String
createdAt: Date
ownerId: String
channelId: String
text: String

###
@ChannelMessages = new Mongo.Collection 'channnelMessages'
ChannelMessages.helpers messagesHelpers

### channelMessages schema

_id: String
createdAt: Date
ownerId: String
targetId: String
text: String

###
@DirectMessages = new Mongo.Collection 'directMessages'
DirectMessages.helpers messagesHelpers

### userData schema

_id: String
channel: [
	id: String
	name: String
	unread: Number
]
direct: [
	id: String
	name: String
	unread: Number
]

###
@UserData = new Mongo.Collection 'userData'
# helpers
Meteor.users.helpers
	data: ->
		UserData.findOne @dataId
