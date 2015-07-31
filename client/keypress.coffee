if Meteor.Device.isDesktop()
	# global key events listener
	keyListener = new window.keypress.Listener document

	keyListener.simple_combo 'shift p', ->
		Router.go '/profile'
	keyListener.simple_combo 'shift c', ->
		Router.go '/config'

	@__keyListener = keyListener
