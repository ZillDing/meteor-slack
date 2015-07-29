Template.activities.helpers
	activities: ->
		Activities.find {},
			sort:
				createdAt: -1
			limit: 20
