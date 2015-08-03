Template.spotlight.onRendered ->
	$search = @$ '.ui.search'
	# get search content from the current user data
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
	# set the search result template
	$.fn.search.settings.templates.standard = (response) ->
		Blaze.toHTMLWithData Template.spotlight_search_results, response

	# set up spotlight modal
	@$('.ui.modal').modal
		duration: 0
		onShow: ->
			$search.find('input').val ''
			__keyListener.stop_listening()
		onVisible: ->
			$search.search
				maxResults: 3
				source: getSearchContent()
				searchFields: ['title']
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
