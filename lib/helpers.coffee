################################################################################
# global helper object across both client and server
# __M_S stands for 'M'eteor 'S'lack
# prefixes:
# 	b_: Boolean
# 	f_: Function
# 	o_: Object
################################################################################
__M_S =
	# check whether the given user id is mentioned in the text
	# by appling regex match - @{username}
	f_isValidUserMention: (userId, text) ->
		username = Meteor.users.findOne(userId)?.username
		return false if _.isEmpty username

		re = new RegExp "@#{username}(\\s|$)"
		re.test text


# Client specific helpers
if Meteor.isClient

	_keyListener = _inputKeyListener = null
	if Meteor.Device.isDesktop()
		# global key events listener
		_keyListener = new window.keypress.Listener document

		_keyListener.simple_combo 'shift p', ->
			Router.go '/profile'
		_keyListener.simple_combo 'shift c', ->
			Router.go '/config'
		_keyListener.simple_combo 'shift h', ->
			Router.go '/help'
		_keyListener.simple_combo 'shift g', ->
			$('.ui.modal.spotlight-modal').modal 'show'
		_keyListener.simple_combo '?', ->
			$('.ui.modal.cheatsheet-modal').modal 'show'


		# global key events listener for input/textarea
		_inputKeyListener = new window.keypress.Listener document

		_inputKeyListener.simple_combo 'esc', ->
			$(':focus').blur()
		_inputKeyListener.simple_combo 'meta enter', ->
			$(':focus').closest('form').submit()


	_.extend __M_S,
		# determine whehter the device is hoverable
		# mainly used before initialize popup
		b_deviceIsHoverable: Meteor.Device.isTV() or Meteor.Device.isDesktop()

		# check whether the given channel id is mentioned in the text
		# by appling regex match - #{name}
		f_isValidChannelMention: (channelId, text) ->
			name = Channels.findOne(channelId)?.name
			return false if _.isEmpty name

			re = new RegExp "##{name}(\\s|$)"
			re.test text

		# alert error
		f_sAlertError: (error, configOverwrite) ->
			sAlert.error
				sAlertTitle: error.error
				message: error.message
			, configOverwrite

		o_keyListener: _keyListener

		o_inputKeyListener: _inputKeyListener


################################################################################
# export the global object to be used in the app
################################################################################
@__M_S = __M_S
