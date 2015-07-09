Template.title.helpers
	channels: ->
		if Meteor.user()?.data
			UserData.findOne(Meteor.user().data).channel
		else
			Channels.find {}

	currentTarget: ->
		Session.get 'chatTarget'

	directChats: ->
		if Meteor.user()?.data
			UserData.findOne(Meteor.user().data).direct.reverse()

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
