Template.status.events
	'click .a.right': ->
		# TODO: hide popup and logout

	'mouseenter .a.right': ->
		# TODO: show popup

	'mouseleave .a.right': ->
		# TODO: hide popup

Template.status.helpers
	avatar: ->
		Meteor.user()?.profile?.avatar ? 'default'
