Template.navbar.events
	'click .sidebar-trigger': ->
		$('.ui.sidebar').sidebar 'toggle'

	'click .utility-trigger': ->
		Session.set '__M_S_showUtility', not Session.get '__M_S_showUtility'
