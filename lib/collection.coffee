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
data:
	channel: [
		id: String
		name: String
		unread: Number
	]
	direct: [
		id: String
		username: String
		unread: Number
	]

###
@UserData = new Mongo.Collection 'userData'
