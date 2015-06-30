################################################################################
# _signedIn
################################################################################
Template.status_signedIn.events
	'click a.right': (event) ->
		# hide popup and logout
		$(event.currentTarget).popup 'hide'
		Router.go '/signout'

Template.status_signedIn.helpers
	avatar: ->
		Meteor.user()?.profile?.avatar ? 'default'

Template.status_signedIn.onRendered ->
	@$('a.right').popup()
