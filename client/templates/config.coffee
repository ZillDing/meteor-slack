Template.config.helpers
	additionalChannels: ->
		if list = Meteor.user()?.data().channel
			idList = _.map list, (o) ->
				o.id
			Channels.find
				_id:
					$nin: idList

	directChats: ->
		Meteor.user()?.data().directData()

	userChannels: ->
		Meteor.user()?.data().channelData()


################################################################################
# _item_channel_user
################################################################################
Template.config_item_channel_user.events
	'click .ui.button': ->
		# delete from user data
		name = Template.currentData().name
		Meteor.call 'removeChat',
			type: 'channel'
			target: name
		, (error, result) ->
			_addErrorNotification error if error

################################################################################
# _item_channel_additional
################################################################################
Template.config_item_channel_additional.events
	'click .ui.button': ->
		# add to user data
		name = Template.currentData().name
		Meteor.call 'addChat',
			type: 'channel'
			target: name
		, (error, result) ->
			_addErrorNotification error if error

################################################################################
# _item_direct
################################################################################
Template.config_item_direct.events
	'click .ui.button': ->
		# remove chat
		username = Template.currentData().name
		Meteor.call 'removeChat',
			type: 'direct'
			target: username
		, (error, result) ->
			_addErrorNotification error if error
