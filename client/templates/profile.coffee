Template.profile.helpers
	joinYear: ->
		console.log Meteor.user().createdAt

	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
