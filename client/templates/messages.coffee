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

	@autorun =>
		data = Template.currentData()
		if (_.isObject data) and not _.isEmpty data
			@subscribe 'targetedMessages', data
			Session.set
				chatType: data.type
				chatTarget: data.target

			switch data.type
				when 'channel'
					@subscribe 'channels'
				when 'direct'
					@subscribe 'allUsers', ->
						Meteor.call 'startDirectChat', data.target, (error, result) ->
							_addErrorNotification error if error


Template.messages.onDestroyed ->
	Session.set 'isChatting', false
