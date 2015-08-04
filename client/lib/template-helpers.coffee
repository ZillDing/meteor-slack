################################################################################
# Helpers for all templates
# Use a global helpers object __M_S
################################################################################
Template.registerHelper '__M_S', ->

	BRAND_NAME: 'TAISS'
	LARGE_AVATAR_DIR: '/images/avatar/large'
	SMALL_AVATAR_DIR: '/images/avatar/small'

	# return '' if this is not the current active item
	# return 'active' if it is the current active item
	# note: this will work with template 'if' check
	isActive: (type, target) ->
		return '' if not Session.equals '__M_S_chatType', type
		if Session.equals '__M_S_chatTarget', target
		then 'active'
		else ''
