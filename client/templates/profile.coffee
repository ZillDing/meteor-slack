isEdittingProfile = new ReactiveVar false

################################################################################
# _currentUser
################################################################################
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
		$form = Template.instance().$ 'form.form'
		$form.form 'validate form'
		if $form.form 'is valid'
			profile = Template.instance().$('form.form').form 'get values'
			Meteor.call 'updateUserProfile', profile, (error, result) ->
				if error
					Session.set 'error', error
				else
					isEdittingProfile.set false
		false

Template.profile_currentUser_edit.helpers
	AVAILABLE_AVATARS: ->
		['default', 'christian', 'elliot', 'helen', 'jenny', 'joe', 'justen', 'laura', 'matt', 'steve', 'stevie']

Template.profile_currentUser_edit.onRendered ->
	@$('.ui.dropdown').dropdown()
	# add form validation
	@$('form.form').form
		fields:
			status:
				identifier: 'status'
				rules: [
					type: 'empty'
					prompt: 'Please enter your status'
				,
					type: 'maxLength[100]'
					prompt: 'Status cannot be longer than 100 characters (including spaces)'
				]

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
