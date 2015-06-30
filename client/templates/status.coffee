Template.status.helpers
	avatar: ->
		fileName = Meteor.user()?.profile?.avatar ? 'default'
		"/avatar/#{fileName}.jpg"
