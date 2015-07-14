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
usersId: [String]

###
@Channels = new Mongo.Collection 'channels'

### channelMessages schema

_id: String
createdAt: Date
ownerId: String
channelId: String
text: String

###
@ChannelMessages = new Mongo.Collection 'channnelMessages'

### channelMessages schema

_id: String
createdAt: Date
ownerId: String
targetId: String
text: String

###
@DirectMessages = new Mongo.Collection 'directMessages'

### userData schema

_id: String
channel: [
	id: String
	unread: Number
]
direct: [
	id: String
	unread: Number
]

###
@UserData = new Mongo.Collection 'userData'


################################################################################
# Helpers
################################################################################
Meteor.users.helpers
	data: ->
		UserData.findOne @dataId

Channels.helpers
	owner: ->
		Meteor.users.findOne @ownerId


messagesHelpers =
	owner: ->
		Meteor.users.findOne @ownerId

ChannelMessages.helpers messagesHelpers
DirectMessages.helpers messagesHelpers

UserData.helpers
	channelData: ->
		_.map @channel, (o) ->
			id: o.id
			name: Channels.findOne(o.id).name
			unread: o.unread

	directData: ->
		_.map @direct, (o) ->
			id: o.id
			name: Meteor.users.findOne(o.id).username
			unread: o.unread
