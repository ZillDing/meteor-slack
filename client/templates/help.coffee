Template.help.helpers
	socialData: ->
		[
			url: 'https://www.google.com/+ZeyuDing'
			class: 'google plus'
			icon: 'google plus'
			label: '+ZeyuDing'
		,
			url: 'https://twitter.com/ZillDing'
			class: 'twitter'
			icon: 'twitter'
			label: '@ZillDing'
		,
			url: 'https://www.facebook.com/zeyu.ding.1'
			class: 'facebook'
			label: 'Zeyu Ding'
		,
			url: 'https://github.com/ZillDing'
			class: 'github'
			label: 'ZillDing'
		,
			url: 'https://www.linkedin.com/in/zeyuding'
			class: 'linkedin'
			label: 'Zeyu Ding'
		]


################################################################################
# _modal
################################################################################
Template.help_modal.onRendered ->
	@$('.modal.help-modal').modal
		onShow: ->
			__keyListener.stop_listening()
		onHidden: ->
			__keyListener.listen()
