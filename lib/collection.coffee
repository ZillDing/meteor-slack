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
	favourite: Boolean
]
direct: [
	id: String
	unread: Number
	favourite: Boolean
]

###
@UserData = new Mongo.Collection 'userData'

### activities schema

_id: String
channelId: String
createdAt: Date
ownerId: String
type: String

###
@Activities = new Mongo.Collection 'activities'


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
			_.extend
				name: Channels.findOne(o.id).name
			, o

	directData: ->
		_.map @direct, (o) ->
			_.extend
				name: Meteor.users.findOne(o.id).username
			, o

Activities.helpers
	channel: ->
		Channels.findOne @channelId
	owner: ->
		Meteor.users.findOne @ownerId
