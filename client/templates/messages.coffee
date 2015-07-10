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
	Session.set 'isChatting', true
	@prevData = null
	@clearUnread = (data) ->
		Meteor.call 'clearUnread', data, (error, result) ->
			_addErrorNotification error if error

	@autorun =>
		@clearUnread @prevData if Meteor.userId() and @prevData

		data = Template.currentData()
		check data,
			type: Match.OneOf 'channel', 'direct'
			target: String
		@prevData = data if Meteor.userId()

		Session.set
			chatType: data.type
			chatTarget: data.target

		@subscribe 'targetedMessages', data
		switch data.type
			when 'channel'
				@subscribe 'channels'
			when 'direct'
				@subscribe 'allUsers', ->
					Meteor.call 'startDirectChat', data.target, (error, result) ->
						_addErrorNotification error if error


Template.messages.onDestroyed ->
	@clearUnread @prevData if Meteor.userId()
	Session.set 'isChatting', false
