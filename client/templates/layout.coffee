Template.layout.onRendered ->
	@$('.ui.sidebar').sidebar()
	# put the following class configuration here because meteor does not allow
	# duplicate class names
	@$('.sidebar-container').attr 'class', 'three wide computer four wide tablet only column'
	@$('.main-container').attr 'class', 'thirteen wide computer twelve wide tablet sixteen wide mobile column'
