Template.messages.helpers
	messages: ->
		switch Session.get 'chatType'
			when 'channel'
				targetId = Channels.findOne(name: Session.get 'chatTarget')._id
				Messages.find
					type: 'channel'
					target: targetId
			when 'direct'
				targetId = Meteor.users.findOne(username: Session.get 'chatTarget')._id
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

Template.messages.onDestroyed ->
	Session.set 'isChatting', false
