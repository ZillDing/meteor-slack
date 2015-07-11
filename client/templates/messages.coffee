Template.messages.helpers
	messages: ->
		chatType = Session.get 'chatType'
		chatTarget = Session.get 'chatTarget'
		switch chatType
			when 'channel'
				targetId = Channels.findOne(name: chatTarget)._id
				Messages.find
					type: 'channel'
					target: targetId
			when 'direct'
				targetId = Meteor.users.findOne(username: chatTarget)._id
				Messages.find
					$and: [
						type: 'direct'
					,
						$or: [
							owner: Meteor.userId()
							target: targetId
						,
							owner: targetId
							target: Meteor.userId()
						]
					]


Template.messages.onCreated ->
	@prevData = null
	@clearUnread = (data) ->
		Meteor.call 'clearUnread', data, (error, result) ->
			_addErrorNotification error if error
	isValid = (data) ->
		if not _.contains ['channel', 'direct'], data.type
			_addErrorNotification
				error: 'Error'
				message: "Invalid chat type: #{data.type}"
			return false
		switch data.type
			when 'channel'
				if not Channels.findOne(name: data.target)
					_addErrorNotification
						error: 'No such channel'
						message: "Could not find channel with name: #{data.target}"
					return false
			when 'direct'
				if not Meteor.users.findOne(username: data.target)
					_addErrorNotification
						error: 'No such user'
						message: "Could not find user with username: #{data.target}"
					return false
		true

	@autorun =>
		data = Template.currentData()
		return if not isValid data
		# @subscribe 'targetedMessages', data
		@subscribe 'targetedMessages', data,
			onStop: (error) ->
				_addErrorNotification error if error
			onReady: =>
				Session.set
					chatType: data.type
					chatTarget: data.target

				return if not Meteor.userId()
				@clearUnread @prevData if @prevData
				@prevData = data
				if data.type is 'direct'
					Meteor.call 'startDirectChat', data.target, (error, result) ->
						_addErrorNotification error if error


Template.messages.onDestroyed ->
	@clearUnread @prevData if Meteor.userId()
	Session.set
		chatType: null
		chatTarget: null
