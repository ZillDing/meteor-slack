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
owner: String

###
@Channels = new Mongo.Collection 'channels'

### message schema

_id: String
avatar: String
createdAt: Date
owner: String
target: String
text: String
type: String
username: String

###
@Messages = new Mongo.Collection 'messages'

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

################################################################################
# Apply helpers
################################################################################
Meteor.users.helpers
	data: ->
		UserData.findOne @dataId
