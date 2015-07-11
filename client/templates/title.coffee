Template.title.events
	'click .ui.button.remove-btn': (event) ->
		$(event.currentTarget).popup 'hide'

		data =
			type: Session.get 'chatType'
			target: Session.get 'chatTarget'
		Meteor.call 'removeChat', data, (error, result) ->
			if error
				_addErrorNotification error
			else
				Router.go '/'

Template.title.helpers
	channels: ->
		if Meteor.user()?.data
			UserData.findOne(Meteor.user().data).channel
		else
			Channels.find {}

	directChats: ->
		if Meteor.user()?.data
			UserData.findOne(Meteor.user().data).direct.reverse()

	prefixSymbol: ->
		switch Session.get 'chatType'
			when 'channel'
				'#'
			when 'direct'
				'@'

Template.title.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		transition: 'drop'

	if __deviceIsHoverable
		@autorun =>
			return if not Meteor.userId()

			text = switch Session.get 'chatType'
				when 'channel' then 'Quit this channel'
				when 'direct' then 'Delete this chat'
			@$('.ui.button.remove-btn').popup
				content: text
