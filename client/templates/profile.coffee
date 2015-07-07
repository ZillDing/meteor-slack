isEdittingProfile = new ReactiveVar false

################################################################################
# _currentUser
################################################################################
Template.profile_currentUser.helpers
	isEdittingProfile: ->
		isEdittingProfile.get()

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
					_addNotification
						type: 'error'
						header: error.error
						message: error.message
				else
					isEdittingProfile.set false
		false

Template.profile_currentUser_edit.helpers
	AVAILABLE_AVATARS: ->
		['default.jpg', 'christian.jpg', 'elliot.jpg', 'helen.jpg', 'jenny.jpg', 'joe.jpg', 'justen.jpg', 'laura.jpg', 'matt.jpg', 'steve.jpg', 'stevie.jpg']

	getAvatarDisplayName: (str) ->
		regexps = [/.jpg$/i, /.png$/i]
		for regexp in regexps
			if regexp.test str
				return str.replace regexp, ''

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
# _users
################################################################################
Template.profile_users.helpers
	hasUsers: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
		.count() isnt 0

	noUserMessage: ->
		if Meteor.userId()
			'Invite your friends!'
		else
			'Quickly join!'

	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()

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

	isHoverable: ->
		__deviceIsHoverable

Template.profile_card.onRendered ->
	if __deviceIsHoverable
		@$('.card .image').dimmer
			on: 'hover'
