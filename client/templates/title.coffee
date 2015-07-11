Template.title.events
	'click .ui.button.remove-btn': (event) ->
		$(event.currentTarget).popup 'hide'

		data =
			type: type = Session.get 'chatType'
			target: target = Session.get 'chatTarget'
		Meteor.call 'removeChat', data, (error, result) ->
			if error
				_addErrorNotification error
			else
				item = Meteor.user().data()["#{type}"][0]
				if item
					Router.go "/#{type}/#{item.name}"
				else
					Router.go '/'

Template.title.helpers
	channels: ->
		if Meteor.user()?.data()
			Meteor.user().data().channel.reverse()
		else
			Channels.find {},
				sort:
					createdAt: -1

	directChats: ->
		if Meteor.user()?.data()
			Meteor.user().data().direct.reverse()

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
