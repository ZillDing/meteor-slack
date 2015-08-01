Meteor.startup ->

	sAlert.config
		effect: 'scale'
		position: 'bottom-right'
		html: true
		offset: 55

	Meteor.users.find
		'status.online': true
	.observeChanges
		added: (id, user) ->
			return if id is Meteor.userId()
			sAlert.info
				sAlertTitle: user.username
				message: 'is online!'
		removed: (id) ->
			return if id is Meteor.userId()
			sAlert.info
				sAlertTitle: Meteor.users.findOne(id).username
				message: 'is offline...'
