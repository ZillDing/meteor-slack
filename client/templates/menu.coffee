Template.menu.helpers
	favouriteCount: ->
		return if not Meteor.user()?.data()

		channelCount = _.filter Meteor.user().data().channel, (o) ->
			o.favourite
		.length
		directCount = _.filter Meteor.user().data().direct, (o) ->
			o.favourite
		.length
		channelCount + directCount

	channels: ->
		if Meteor.user()?.data()
			Meteor.user().data().channelData().reverse()
		else
			# put the new ones on top
			Channels.find {},
				sort:
					createdAt: -1

	directChats: ->
		if Meteor.user()?.data()
			Meteor.user().data().directData().reverse()


################################################################################
# _createNewChannelItem
################################################################################
Template.menu_createNewChannelItem.events
	'click': ->
		Session.set '__M_S_isAddingNewChannel', true


################################################################################
# _addNewChannelItem
################################################################################
Template.menu_addNewChannelItem.events
	'click i.cancel': ->
		Session.set '__M_S_isAddingNewChannel', false

	'click i.checkmark': (event, template) ->
		template.$('form.form').submit()

	'keyup input': (event, template) ->
		text = $(event.currentTarget).val()
		if text
			template.$('i.checkmark').show()
		else
			template.$('i.checkmark').hide()

	'submit form.form': (event, template) ->
		return false if not name = template.$('input').val().trim()
		# validate the name
		if /\W/.test name
			sAlert.error
				sAlertTitle: 'Add channel failed!'
				message: "Invalid channel name: #{name}. Alphanumeric character (including _) only."
			return false
		if Channels.findOne(name: name)
			# this channel alr exists
			sAlert.error
				sAlertTitle: 'Add channel failed!'
				message: "Channel with this name already exists: #{name}"
			return false

		$ '.ui.modal.menu-modal'
		.data 'newChannelName', name
		.modal 'show'
		# prevent default form submit
		false

Template.menu_addNewChannelItem.onRendered ->
	@$('input').focus()


################################################################################
# _createNewDirectChatItem
################################################################################
Template.menu_createNewDirectChatItem.events
	'click': ->
		Session.set '__M_S_isAddingNewDirectChat', true


################################################################################
# _addNewDirectChatItem
################################################################################
Template.menu_addNewDirectChatItem.events
	'click a.sidebar-menu-item': ->
		Session.set '__M_S_isAddingNewDirectChat', false

	'click i.cancel': ->
		Session.set '__M_S_isAddingNewDirectChat', false

	'submit form.form': ->
		false

Template.menu_addNewDirectChatItem.helpers
	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
		,
			sort:
				username: 1

Template.menu_addNewDirectChatItem.onRendered ->
	@$('input').focus()


################################################################################
# _modal
################################################################################
Template.menu_modal.onRendered ->
	@$('.modal.menu-modal').modal
		closable: false
		onApprove: ->
			name = $(@).data 'newChannelName'
			Meteor.call 'createChannel', name, (error, result) ->
				if error
					__M_S.f_sAlertError error
				else
					Session.set '__M_S_isAddingNewChannel', false
					Router.go "/channel/#{name}"
