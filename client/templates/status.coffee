# maximum number of chars allowed to display in the status
# if length is bigger than 10, will only display the first 9 char
# + '...'
MAX_STATUS_CHAR = 10

################################################################################
# _signedIn
################################################################################
Template.status_signedIn.events
	'click .sign-out': (event) ->
		# logout
		Meteor.logout ->
			Router.go '/signin'

Template.status_signedIn.helpers
	userProfile: ->
		status = Meteor.user()?.profile?.status
		if (_.isString status) and status.length > MAX_STATUS_CHAR
			status: "#{status.substring 0, MAX_STATUS_CHAR-1}..."
		else
			status: status

Template.status_signedIn.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		direction: 'upward'

	if __deviceIsHoverable
		@$('i.sign.out').popup()

		@autorun =>
			status = Meteor.user()?.profile?.status
			if (_.isString status) and status.length > MAX_STATUS_CHAR
				@$('div.description small').popup()
			else
				@$('div.description small').popup 'destroy'
