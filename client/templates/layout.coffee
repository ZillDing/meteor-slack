Template.layout.events
	'click .sidebar-trigger': ->
		Template.instance().$('.ui.sidebar').sidebar 'toggle'

Template.layout.onRendered ->
	@$('.ui.sidebar').sidebar 'setting', 'transition', 'overlay'
	# put the following class configuration here because meteor does not allow
	# duplicate class names
	@$('.sidebar-container').attr 'class', 'three wide computer four wide tablet only column flex-column-container'
	@$('.main-container').attr 'class', 'thirteen wide computer twelve wide tablet sixteen wide mobile column flex-column-container'

	# hide sidebar when window resizes
	$(window).on 'resize', =>
		@$('.ui.sidebar').sidebar 'hide' if @$('.ui.sidebar').sidebar 'is visible'

Template.layout.onDestroyed ->
	$(window).off 'resize'
