# CONSTANTS
Template.registerHelper 'BRAND_NAME', ->
	'TAISS'

Template.registerHelper 'LARGE_AVATAR_DIR', ->
	'/images/avatar/large'

Template.registerHelper 'SMALL_AVATAR_DIR', ->
	'/images/avatar/small'

# variables
Template.registerHelper 'isChatting', ->
	Session.get 'isChatting'
