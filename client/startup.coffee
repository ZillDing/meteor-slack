Meteor.startup ->

	sAlert.config
		effect: 'scale'
		html: true
		offset: 55
		position: 'bottom-right'

	_getLink = (type, name) ->
		"<a href=\"/#{type}/#{name}\">#{name}</a>"
	_notify = (title) ->
		return if not Notification
		return if Notification.permission is 'denied'

		if Notification.permission is 'granted'
			new Notification title
		else
			Notification.requestPermission (permission) ->
				if permission is 'granted'
					new Notification title

	alertSound = new buzz.sound '/sounds/alert.mp3'

	Notifications.find().observeChanges
		added: (id, notification) ->
			switch notification.type
				when 'new-user'
					sAlert.success
						sAlertTitle: _getLink 'direct', notification.ownerName
						message: 'has joined the team!'
				when 'new-channel'
					sAlert.success
						sAlertTitle: _getLink 'channel', notification.channelName
						message: 'has been created!'
				when 'direct-message'
					sAlert.info
						sAlertTitle: _getLink 'direct', notification.ownerName
						message: 'sent you a message.'
					_notify "New message from #{notification.ownerName}"
					alertSound.play()
				when 'user-mention'
					sAlert.info
						sAlertTitle: notification.ownerName
						message: "mentioned you in channel: #{_getLink 'channel', notification.channelName}."
					_notify "New mention by #{notification.ownerName}"
					alertSound.play()
				when 'user-status'
					if notification.ownerStatus?.online
						title = _getLink 'direct', notification.ownerName
						message = 'is <em>online</em>!'
					else
						title = notification.ownerName
						message = 'is <em>offline</em>...'
					sAlert.info
						sAlertTitle: title
						message: message

	# request desktop notification permission
	if Notification and Notification.permission not in ['granted', 'denied']
		Notification.requestPermission()
