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
ownerId: String
type: String('new-user', 'new-channel')

###
@Activities = new Mongo.Collection 'activities'

### notifications schema

_id: String
channelId: String
ownerId: String
targetId: String
type: String('new-user', 'new-channel', 'direct-message', 'channel-mention')

###
@Notifications = new Mongo.Collection 'notifications'


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

Notifications.helpers
	channel: ->
		Channels.findOne @channelId
	owner: ->
		Meteor.users.findOne @ownerId
	target: ->
		Meteor.users.findOne @targetId


################################################################################
# EasySearch
################################################################################
EasySearch.createSearchIndex 'users',
	field: 'username'
	collection: Meteor.users
	query: (searchString, opts) ->
		# default query
		query = EasySearch.getSearcher(@use).defaultQuery @, searchString
		# filter current user
		query.$and = [_id: $ne: Meteor.userId()]
		query
	sort: ->
		username: 1
