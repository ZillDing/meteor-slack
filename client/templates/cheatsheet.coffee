Template.cheatsheet.onRendered ->
	@$('.ui.modal').modal
		onShow: ->
			__M_S.o_keyListener.stop_listening()
		onHidden: ->
			__M_S.o_keyListener.listen()
