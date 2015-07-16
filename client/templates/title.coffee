Template.title.events
	'click .ui.button.remove-btn': (event, template) ->
		$(event.currentTarget).popup 'hide'
		$(event.currentTarget).blur() # this is to fix the focusing bug
		$('.ui.modal.title-modal').modal 'show'

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

	if __deviceIsHoverable
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
					_sAlertError error
				else
					item = _.last Meteor.user().data()["#{type}Data"]()
					if item
						Router.go "/#{type}/#{item.name}"
					else
						Router.go '/'
