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

	if __M_S.b_deviceIsHoverable
		@autorun =>
			status = Meteor.user().profile.status
			if (_.isString status) and status.length > 10
				@$('div.description small').popup
					content: status
					variation: 'inverted'
			else
				@$('div.description small').popup 'destroy'
