################################################################################
# utils
################################################################################
String.prototype.capitalize = ->
	@charAt(0).toUpperCase() + @substring 1

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

Template.registerHelper '_getUserProfileStatus', (profile) ->
	profile?.status ? 'online'
