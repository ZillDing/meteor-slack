Template.registerHelper 'LARGE_AVATAR_DIR', ->
	'/images/avatar/large'

Template.registerHelper 'SMALL_AVATAR_DIR', ->
	'/images/avatar/small'

Template.registerHelper 'isChatting', ->
	Session.get 'isChatting'
