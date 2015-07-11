################################################################################
# global variables
################################################################################
@__deviceIsHoverable = Meteor.Device.isTV() or Meteor.Device.isDesktop()


################################################################################
# Helpers for all templates
################################################################################
# CONSTANTS
Template.registerHelper 'BRAND_NAME', ->
	'TAISS'

Template.registerHelper 'LARGE_AVATAR_DIR', ->
	'/images/avatar/large'

Template.registerHelper 'SMALL_AVATAR_DIR', ->
	'/images/avatar/small'

# functions
Template.registerHelper '_isActiveItem', (type, target) ->
	return false if not Session.equals 'chatType', type

	if Session.equals 'chatTarget', target
	then true
	else false

Template.registerHelper '_getJoinTime', (date) ->
	moment(date).format 'YYYY, MMM'

Template.registerHelper '_shouldShowUnreadLabel', (unread) ->
	_.isNumber(unread) and unread > 0
