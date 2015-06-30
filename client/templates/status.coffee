Template.status.helpers
	avatar: ->
		Meteor.user()?.profile?.avatar ? 'default'
