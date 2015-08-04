Template.title.events
	'click .ui.button.favourite-btn': (event) ->
		$(event.currentTarget).popup 'hide'
		$(event.currentTarget).blur() # this is to fix the focusing bug
		data =
			type: Session.get 'chatType'
			target: Session.get 'chatTarget'
		Meteor.call 'toggleFavourite', data, (error, result) ->
			__M_S.f_sAlertError error if error

	'click .ui.button.remove-btn': (event) ->
		$(event.currentTarget).popup 'hide'
		$(event.currentTarget).blur() # this is to fix the focusing bug
		$('.ui.modal.title-modal').modal 'show'

	'click .ui.button.utility-trigger': ->
		Session.set 'showUtility', not Session.get 'showUtility'


Template.title.helpers
	channels: ->
		if Meteor.user()?.data()
			Meteor.user().data().channelData().reverse()
		else
			Channels.find {},
				sort:
					createdAt: -1

	currentChannelSize: ->
		if Session.equals 'chatType', 'channel'
			Channels.findOne(name: Session.get 'chatTarget')?.usersId.length

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

		@autorun =>
			return if not Meteor.userId()

			text = switch Session.get 'chatType'
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
				type: type = Session.get 'chatType'
				target: target = Session.get 'chatTarget'
			Meteor.call 'removeChat', data, (error, result) ->
				if error
					__M_S.f_sAlertError error
				else
					item = _.last Meteor.user().data()["#{type}Data"]()
					if item
						Router.go "/#{type}/#{item.name}"
					else
						Router.go '/'
