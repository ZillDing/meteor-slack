Template.spotlight.onRendered ->
	$search = @$ '.ui.search'
	getSearchContent = ->
		result = []
		userData = Meteor.user().data()
		for o in userData.channelData()
			result.push
				title: o.name
				description: 'channel'
		for o in userData.directData()
			result.push
				title: o.name
				description: 'direct'
		result

	@$('.ui.modal').modal
		duration: 0
		onShow: ->
			$search.find('input').val ''
			__keyListener.stop_listening()
		onVisible: ->
			$search.search
				maxResults: 3
				source: getSearchContent()
				onSelect: (result, response) ->
					$search.closest('.ui.modal').modal 'hide'
					Router.go "/#{result.description}/#{result.title}"

			# FIXME
			# cannot use $input.focus() since it does not work
			Meteor.setTimeout ->
				$search.find('input').focus()
			, 0
		onHidden: ->
			__keyListener.listen()
