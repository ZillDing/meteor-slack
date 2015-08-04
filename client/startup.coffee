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

	Notifications.find().observeChanges
		added: (id, notification) ->
			switch notification.type
				when 'new-user'
					sAlert.success
						sAlertTitle: notification.ownerName
						message: 'has joined the team!'
				when 'new-channel'
					sAlert.success
						sAlertTitle: notification.channelName
						message: 'has been created!'
				when 'direct-message'
					sAlert.info
						sAlertTitle: 'New message'
						message: "from #{notification.ownerName}"
				when 'channel-mention'
					sAlert.info
						sAlertTitle: 'You are mentioned'
						message: "in channel: #{notification.channelName} by #{notification.ownerName}"
