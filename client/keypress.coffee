if Meteor.Device.isDesktop()
	# global key events listener
	keyListener = new window.keypress.Listener document

	keyListener.simple_combo 'shift p', ->
		Router.go '/profile'
	keyListener.simple_combo 'shift c', ->
		Router.go '/config'
	keyListener.simple_combo 'shift h', ->
		Router.go '/help'
	keyListener.simple_combo '?', ->
		$('.ui.modal.help-modal').modal 'show'

	@__keyListener = keyListener
