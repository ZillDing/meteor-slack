Template.title.helpers
	channels: ->
		Channels.find {}

	currentTarget: ->
		Session.get 'chatTarget'

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
