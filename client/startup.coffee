Meteor.startup ->

	sAlert.config
		effect: 'scale'
		html: true
		offset: 55
		position: 'bottom-right'

	getLink = (type, name) ->
		"<a href=\"/#{type}/#{name}\">#{name}</a>"

	Meteor.users.find
		'status.online': true
	.observeChanges
		added: (id, user) ->
			return if id is Meteor.userId()
			sAlert.info
				sAlertTitle: getLink 'direct', user.username
				message: 'is <em>online</em>!'
		removed: (id) ->
			return if id is Meteor.userId()
			sAlert.info
				sAlertTitle: Meteor.users.findOne(id).username
				message: 'is <em>offline</em>...'

	Notifications.find().observeChanges
		added: (id, notification) ->
			switch notification.type
				when 'new-user'
					sAlert.success
						sAlertTitle: getLink 'direct', notification.ownerName
						message: 'has joined the team!'
				when 'new-channel'
					sAlert.success
						sAlertTitle: getLink 'channel', notification.channelName
						message: 'has been created!'
				when 'direct-message'
					sAlert.info
						sAlertTitle: getLink 'direct', notification.ownerName
						message: 'sent you a message.'
				when 'channel-mention'
					sAlert.info
						sAlertTitle: notification.ownerName
						message: "mentioned you in channel: #{getLink 'channel', notification.channelName}."
