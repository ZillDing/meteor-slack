################################################################################
# _signedIn
################################################################################
Template.status_signedIn.events
	'click .sign-out': (event) ->
		# logout
		Meteor.logout ->
			Router.go '/signin'

Template.status_signedIn.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		direction: 'upward'

	if __M_S.deviceIsHoverable
		@$('i.sign.out').popup()

		@autorun =>
			status = Meteor.user().profile.status
			if (_.isString status) and status.length > @MAX_STATUS_CHAR
				@$('div.description small').popup()
			else
				@$('div.description small').popup 'destroy'
