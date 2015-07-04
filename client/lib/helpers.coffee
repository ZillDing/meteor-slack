################################################################################
# CONSTANTS
################################################################################
Template.registerHelper 'BRAND_NAME', ->
	'TAISS'

Template.registerHelper 'LARGE_AVATAR_DIR', ->
	'/images/avatar/large'

Template.registerHelper 'SMALL_AVATAR_DIR', ->
	'/images/avatar/small'

################################################################################
# variables
################################################################################
Template.registerHelper '__isChatting', ->
	Session.get 'isChatting'

################################################################################
# functions
################################################################################
Template.registerHelper '_getJoinTime', (date) ->
	moment(date).format 'YYYY, MMM'

Template.registerHelper '_getUserProfileAvatar', (profile) ->
	profile?.avatar ? 'default'
