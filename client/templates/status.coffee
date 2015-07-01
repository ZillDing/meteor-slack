################################################################################
# _signedIn
################################################################################
Template.status_signedIn.events
	'click i.sign.out': (event) ->
		# hide popup and logout
		$(event.currentTarget).popup 'hide'
		Meteor.logout ->
			Router.go '/signin'

Template.status_signedIn.helpers
	avatar: ->
		Meteor.user()?.profile?.avatar ? 'default'

Template.status_signedIn.onRendered ->
	@$('i.sign.out').popup()
