Template.navbar.events
	'click .sidebar-trigger': ->
		$('.ui.sidebar').sidebar 'toggle'

	'click .utility-trigger': ->
		Session.set 'showUtility', not Session.get 'showUtility'
