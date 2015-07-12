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


### message schema

_id: String
createdAt: Date
ownerId: String
target: String
text: String
type: String

###
@Messages = new Mongo.Collection 'messages'
# helpers
Messages.helpers
	owner: ->
		Meteor.users.findOne @ownerId


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
