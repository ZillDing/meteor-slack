isEdittingProfile = new ReactiveVar false
currentUserProfile = new ReactiveVar Meteor.user()?.profile

################################################################################
# _currentUser
################################################################################
Template.profile_currentUser.events
	'click .edit-btn': ->
		# TODO: edit current user profile
		alert Template.currentData().username

Template.profile_currentUser.helpers
	isEdittingProfile: ->
		isEdittingProfile.get()

Template.profile_currentUser.onCreated ->
	@subscribe 'userData'

Template.profile_currentUser.onRendered ->
	if Meteor.Device.isDesktop()
		@$('.card .image').dimmer
			on: 'hover'

################################################################################
# _currentUser_edit
################################################################################
Template.profile_currentUser_edit.events
	'click .cancel-btn': ->
		isEdittingProfile.set false

	'submit form.form': ->
		alert 'save profile'
		false

Template.profile_currentUser_edit.helpers
	AVAILABLE_AVATARS: ->
		['christian', 'elliot', 'helen', 'jenny', 'joe', 'justen', 'laura', 'matt', 'steve', 'stevie']

Template.profile_currentUser_edit.onRendered ->
	@$('.ui.dropdown').dropdown()

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
# _card
################################################################################
Template.profile_card.events
	'click .action-btn': ->
		# TODO
		if Meteor.userId() is userId = Template.currentData()._id
			# edit current user profile
			isEdittingProfile.set true
		else
			# start private chat with this user
			alert "start private chat with #{userId}"

Template.profile_card.helpers
	actionIcon: ->
		if Template.currentData()._id is Meteor.userId()
		then 'edit'
		else 'comments'

	actionLabel: ->
		if Template.currentData()._id is Meteor.userId()
		then 'Edit'
		else 'Chat'

Template.profile_card.onRendered ->
	if Meteor.Device.isDesktop()
		@$('.card .image').dimmer
			on: 'hover'
