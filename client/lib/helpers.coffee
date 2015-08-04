################################################################################
# global helper object
# namespace by '__M_S' (stands for 'M'eteor 'S'lack)
################################################################################
@__M_S =
	###
	variables
	###
	# determine whehter the device is hoverable
	# mainly used before initialize popup
	deviceIsHoverable: Meteor.Device.isTV() or Meteor.Device.isDesktop()

	###
	functions
	prefix by 'f_'
	###
	f_sAlertError: (error, configOverwrite) ->
		sAlert.error
			sAlertTitle: error.error
			message: error.message
		, configOverwrite



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
# return '' if this is not the current active item
# return 'active' if it is the current active item
# note: this will work with template 'if' check
Template.registerHelper '_isActive', (type, target) ->
	return '' if not Session.equals 'chatType', type

	if Session.equals 'chatTarget', target
	then 'active'
	else ''
