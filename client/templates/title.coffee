Template.title.events
	'click .ui.button': (event) ->
		$(event.currentTarget).popup 'hide'
		$(event.currentTarget).blur() # this is to fix the focusing bug

	'click .ui.button.favourite-btn': (event) ->
		data =
			type: Session.get '__M_S_chatType'
			target: Session.get '__M_S_chatTarget'
		Meteor.call 'toggleFavourite', data, (error, result) ->
			__M_S.f_sAlertError error if error

	'click .ui.button.remove-btn': (event) ->
		$('.ui.modal.title-modal').modal 'show'

	'click .ui.button.utility-trigger': ->
		Session.set '__M_S_showUtility', not Session.get '__M_S_showUtility'


Template.title.helpers
	channels: ->
		if Meteor.user()?.data()
			Meteor.user().data().channelData().reverse()
		else
			Channels.find {},
				sort:
					createdAt: -1

	currentChannelSize: ->
		if Session.equals '__M_S_chatType', 'channel'
			Channels.findOne(name: Session.get '__M_S_chatTarget')?.usersId.length

	directChats: ->
		if Meteor.user()?.data()
			Meteor.user().data().directData().reverse()


Template.title.onRendered ->
	@$('.ui.dropdown').dropdown
		action: 'hide'
		transition: 'drop'

	if __M_S.b_deviceIsHoverable
		@$('.ui.button.favourite-btn').popup
			content: 'Toggle favourite'
			position: 'bottom center'

		@$('.ui.button.utility-trigger').popup
			content: 'Toggle utility'
			position: 'bottom right'

		@autorun =>
			return if not Meteor.userId()

			text = switch Session.get '__M_S_chatType'
				when 'channel' then 'Quit this channel'
				when 'direct' then 'Delete this chat'
			@$('.ui.button.remove-btn').popup
				content: text
				position: 'bottom center'

################################################################################
# _modal
################################################################################
Template.title_modal.onRendered ->
	@$('.ui.modal').modal
		closable: false
		onApprove: ->
			# hide modal first in order to let the notification work
			$(@).modal 'hide'
			# remove chat
			data =
				type: type = Session.get '__M_S_chatType'
				target: target = Session.get '__M_S_chatTarget'
			Meteor.call 'removeChat', data, (error, result) ->
				if error
					__M_S.f_sAlertError error
				else
					item = _.last Meteor.user().data()["#{type}Data"]()
					if item
						Router.go "/#{type}/#{item.name}"
					else
						Router.go '/'
