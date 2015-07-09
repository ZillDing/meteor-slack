Template.title.helpers
	channels: ->
		if id = Meteor.userId()
			UserData.findOne
				owner: id
			.data.channel
		else
			Channels.find {}

	currentTarget: ->
		Session.get 'chatTarget'

	directChats: ->
		if id = Meteor.userId()
			UserData.findOne
				owner: id
			.data.direct.reverse()

	prefixSymbol: ->
		switch Session.get 'chatType'
			when 'channel'
				'#'
			when 'direct'
				'@'

Template.title.onCreated ->
	if Meteor.userId()
		@subscribe 'currentUser'
	else
		@subscribe 'channels'

Template.title.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		transition: 'drop'
