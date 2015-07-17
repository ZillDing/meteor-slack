Template.layout.onCreated ->
	# hide sidebar when window resizes
	$(window).on 'resize', =>
		@$('.ui.sidebar').sidebar 'hide' if @$('.ui.sidebar').sidebar 'is visible'

Template.layout.onRendered ->
	@$('.ui.sidebar').sidebar 'setting', 'transition', 'overlay'
	# put the following class configuration here because meteor does not allow
	# duplicate class names
	@$('#sidebar-container').attr 'class', 'three wide computer four wide tablet only column flex-container flex-column-container'

	_adjustLayout()

Template.layout.onDestroyed ->
	$(window).off 'resize'
