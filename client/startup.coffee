Meteor.startup ->

	sAlert.config
		effect: 'scale'
		html: true
		offset: 55
		position: 'bottom-right'

	_getLink = (type, name) ->
		"<a href=\"/#{type}/#{name}\">#{name}</a>"

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
				when 'channel-mention'
					sAlert.info
						sAlertTitle: notification.ownerName
						message: "mentioned you in channel: #{_getLink 'channel', notification.channelName}."
				when 'user-status'
					message = if notification.ownerStatus?.online
					then 'is <em>online</em>!'
					else 'is <em>offline</em>...'
					sAlert.info
						sAlertTitle: notification.ownerName
						message: message
