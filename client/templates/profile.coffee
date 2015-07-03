Template.profile.helpers
	avatar: ->
		Meteor.user()?.profile?.avatar ? 'default'

	user: ->
		Meteor.user()

	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
