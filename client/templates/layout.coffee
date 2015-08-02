Template.layout.events
	'focus input, focus textarea': (event) ->
		__keyListener.stop_listening() if Meteor.Device.isDesktop()

	'blur input, blur textarea': (event) ->
		__keyListener.listen() if Meteor.Device.isDesktop()


Template.layout.onRendered ->
	# hide sidebar when window resizes
	$(window).on 'resize', =>
		@$('.ui.sidebar').sidebar 'hide' if @$('.ui.sidebar').sidebar 'is visible'

	# set up sidebar transition animation
	@$('.ui.sidebar').sidebar 'setting', 'transition', 'overlay'

	if Meteor.Device.isDesktop()
		@autorun ->
			if Meteor.userId()
				__keyListener.listen()
			else
				__keyListener.stop_listening()


Template.layout.onDestroyed ->
	$(window).off 'resize'
	__keyListener.destroy() if Meteor.Device.isDesktop()
