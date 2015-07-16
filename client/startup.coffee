Meteor.startup ->

	sAlert.config
		effect: 'scale'
		position: 'bottom-right'
		timeout: 0
		html: true
		onRouteClose: true
		stack: true
		offset: 0

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
