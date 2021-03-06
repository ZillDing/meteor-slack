################################################################################
# _currentUser
################################################################################
Template.profile_currentUser.onRendered ->
	if Meteor.Device.isDesktop()
		@$('.card .image').dimmer
			on: 'hover'

Template.profile_currentUser.onDestroyed ->
	Session.set '__M_S_isEdittingProfile', false


################################################################################
# _currentUser_edit
################################################################################
Template.profile_currentUser_edit.events
	'click .cancel-btn': ->
		Session.set '__M_S_isEdittingProfile', false

	'submit form.form': (event, template) ->
		$form = template.$ 'form.form'
		$form.form 'validate form'
		if $form.form 'is valid'
			profile = $form.form 'get values'
			Meteor.call 'updateUserProfile', profile, (error, result) ->
				if error
					__M_S.f_sAlertError error
				else
					Session.set '__M_S_isEdittingProfile', false
		false

Template.profile_currentUser_edit.helpers
	AVAILABLE_AVATARS: ->
		[
			'default.jpg',
			'christian.jpg',
			'daniel.jpg',
			'elliot.jpg', 'elyse.png', 'eve.png',
			'helen.jpg',
			'jenny.jpg', 'joe.jpg', 'justen.jpg',
			'kristy.png',
			'laura.jpg', 'lena.png',
			'mark.png', 'matt.jpg', 'matthew.png', 'molly.png',
			'rachel.png',
			'steve.jpg', 'stevie.jpg',
			'veronika.jpg'
		]

	getAvatarDisplayName: (str) ->
		regexps = [/.jpg$/i, /.png$/i]
		for regexp in regexps
			if regexp.test str
				return str.replace regexp, ''

Template.profile_currentUser_edit.onRendered ->
	@$('.ui.dropdown').dropdown()
	@$('textarea').autosize()
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

	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()


################################################################################
# _card
################################################################################
Template.profile_card.events
	'click .action-btn': ->
		if Meteor.userId() is userId = Template.currentData()._id
			# edit current user profile
			Session.set '__M_S_isEdittingProfile', true
		else
			# start private chat with this user
			Router.go "/direct/#{Template.currentData().username}"

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
		__M_S.b_deviceIsHoverable

	statusLabelColor: ->
		if Template.currentData().status?.online
		then 'green'
		else 'grey'

Template.profile_card.onRendered ->
	if __M_S.b_deviceIsHoverable
		@$('.card .image').dimmer
			on: 'hover'
