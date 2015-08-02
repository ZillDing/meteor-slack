Template.cheatsheet.onRendered ->
	if Meteor.Device.isDesktop()
		@$('.ui.modal').modal
			onShow: ->
				__keyListener.stop_listening()
			onHidden: ->
				__keyListener.listen()
