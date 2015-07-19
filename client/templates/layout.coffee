Template.layout.onCreated ->
	# hide sidebar when window resizes
	$(window).on 'resize', =>
		@$('.ui.sidebar').sidebar 'hide' if @$('.ui.sidebar').sidebar 'is visible'

Template.layout.onRendered ->
	@$('.ui.sidebar').sidebar 'setting', 'transition', 'overlay'

Template.layout.onDestroyed ->
	$(window).off 'resize'
