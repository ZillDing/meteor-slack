################################################################################
# _signedIn
################################################################################
Template.status_signedIn.events
	'click .sign-out': (event) ->
		# logout
		Meteor.logout ->
			Router.go '/signin'

Template.status_signedIn.helpers
	profileStatus: ->
		max = Template.instance().MAX_STATUS_CHAR
		status = Meteor.user().profile.status

		if (_.isString status) and status.length > max
		then "#{status.substring 0, max-1}..."
		else status

Template.status_signedIn.onCreated ->
	# maximum number of chars allowed to display in the status
	# if length is bigger than 10, will only display the first 9 char
	# + '...'
	@MAX_STATUS_CHAR = 10

Template.status_signedIn.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		direction: 'upward'

	if __deviceIsHoverable
		@$('i.sign.out').popup()

		@autorun =>
			status = Meteor.user().profile.status
			if (_.isString status) and status.length > @MAX_STATUS_CHAR
				@$('div.description small').popup()
			else
				@$('div.description small').popup 'destroy'
