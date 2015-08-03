Template.cheatsheet.onRendered ->
	@$('.ui.modal').modal
		onShow: ->
			__keyListener.stop_listening()
		onHidden: ->
			__keyListener.listen()
