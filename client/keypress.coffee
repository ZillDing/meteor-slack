if Meteor.Device.isDesktop()
	# global key events listener
	keyListener = new window.keypress.Listener document

	keyListener.simple_combo 'shift p', ->
		Router.go '/profile'
	keyListener.simple_combo 'shift c', ->
		Router.go '/config'
	keyListener.simple_combo 'shift h', ->
		Router.go '/help'
	keyListener.simple_combo 'shift g', ->
		$('.ui.modal.spotlight-modal').modal 'show'
	keyListener.simple_combo '?', ->
		$('.ui.modal.cheatsheet-modal').modal 'show'


	# global key events listener for input/textarea
	inputKeyListener = new window.keypress.Listener document

	inputKeyListener.simple_combo 'esc', ->
		$(':focus').blur()
	inputKeyListener.simple_combo 'meta enter', ->
		$(':focus').closest('form').submit()


	# export global variables
	@__keyListener = keyListener
	@__inputKeyListener = inputKeyListener
