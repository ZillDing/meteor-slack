################################################################################
# _currentUser
################################################################################
Template.profile_currentUser.events
	'click .edit-btn': ->
		# TODO: edit current user profile
		alert Template.currentData().username

Template.profile_currentUser.onCreated ->
	@subscribe 'userData'

Template.profile_currentUser.onRendered ->
	if Meteor.Device.isDesktop()
		@$('.card .image').dimmer
			on: 'hover'

################################################################################
# _buddies
################################################################################
Template.profile_buddies.helpers
	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()

Template.profile_buddies.onCreated ->
	@subscribe 'allUsersData'

################################################################################
# _buddy
################################################################################
Template.profile_buddy.events
	'click .chat-btn': ->
		# TODO start chat with this buddy
		alert Template.currentData().username

Template.profile_buddy.onRendered ->
	if Meteor.Device.isDesktop()
		@$('.card .image').dimmer
			on: 'hover'
