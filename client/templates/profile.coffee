Template.profile.helpers
	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
