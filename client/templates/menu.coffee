isAddingANewChannel = new ReactiveVar false
isAddingANewDirectChat = new ReactiveVar false

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

	isAddingANewChannel: ->
		isAddingANewChannel.get()

	isAddingANewDirectChat: ->
		isAddingANewDirectChat.get()


################################################################################
# _createNewChannelItem
################################################################################
Template.menu_createNewChannelItem.events
	'click': ->
		isAddingANewChannel.set true


################################################################################
# _addNewChannelItem
################################################################################
Template.menu_addNewChannelItem.events
	'click i.cancel': ->
		isAddingANewChannel.set false

	'submit form.form': ->
		return false if not name = Template.instance().$('input').val()
		# validate the name
		if Channels.findOne(name: name)
			# this channel alr exists
			sAlert.error
				sAlertTitle: 'Add channel failed!'
				message: "Channel with this name already exists: #{name}"
			return false

		$ '.ui.modal.menu-modal'
		.modal
			closable: false
			onApprove: ->
				Meteor.call 'createChannel', name, (error, result) ->
					if error
						_sAlertError error
					else
						isAddingANewChannel.set false
						Router.go "/channel/#{name}"
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
		isAddingANewDirectChat.set true


################################################################################
# _addNewDirectChatItem
################################################################################
Template.menu_addNewDirectChatItem.events
	'click a.sidebar-menu-item': ->
		isAddingANewDirectChat.set false

	'click i.cancel': ->
		isAddingANewDirectChat.set false

	'keyup input': (event, template) ->
		text = event.currentTarget.value.toLowerCase()
		# only search when the input value changes
		if text isnt template.prevSearchValue
			handle = template.prevTimeoutHandle
			Meteor.clearTimeout handle if handle
			template.prevSearchValue = text
			template.prevTimeoutHandle = Meteor.setTimeout ->
				pattern = new RegExp text.split('').join('.*'), 'i'
				template.searchPattern.set pattern
			, 300

Template.menu_addNewDirectChatItem.helpers
	users: ->
		Meteor.users.find
			_id:
				$ne: Meteor.userId()
			username: Template.instance().searchPattern.get()
		,
			sort:
				username: 1

Template.menu_addNewDirectChatItem.onCreated ->
	@searchPattern = new ReactiveVar /.*/i

Template.menu_addNewDirectChatItem.onRendered ->
	@$('input').focus()
