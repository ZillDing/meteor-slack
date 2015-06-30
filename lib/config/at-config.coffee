# remove the default fields
AccountsTemplates.removeField 'email'
AccountsTemplates.removeField 'password'

# add form fields
AccountsTemplates.addFields [
	_id: 'username'
	type: 'text'
	displayName: 'username'
	required: true
	minLength: 3
,
	_id: 'password'
	type: 'password'
	required: true
	minLength: 3
]
