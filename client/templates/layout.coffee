Template.layout.events
	'focus input, focus textarea': (event) ->
		if Meteor.Device.isDesktop()
			__M_S.o_keyListener.stop_listening()
			__M_S.o_inputKeyListener.listen()

	'blur input, blur textarea': (event) ->
		if Meteor.Device.isDesktop()
			__M_S.o_inputKeyListener.stop_listening()
			__M_S.o_keyListener.listen()


Template.layout.onRendered ->
	# hide sidebar when window resizes
	$(window).on 'resize', =>
		@$('.ui.sidebar').sidebar 'hide' if @$('.ui.sidebar').sidebar 'is visible'

	# set up sidebar transition animation
	@$('.ui.sidebar').sidebar 'setting', 'transition', 'overlay'

	if Meteor.Device.isDesktop()
		@autorun ->
			if Meteor.userId()
				__M_S.o_keyListener.listen()
			else
				__M_S.o_keyListener.stop_listening()


Template.layout.onDestroyed ->
	$(window).off 'resize'
