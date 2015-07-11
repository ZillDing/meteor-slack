# remove the default fields
AccountsTemplates.removeField 'email'
AccountsTemplates.removeField 'password'

# add form fields
AccountsTemplates.addFields [
	_id: 'username'
	type: 'text'
	displayName:
		signUp: 'Username (please use lower case letters)'
	required: true
	minLength: 3
	trim: true
	lowercase: true
,
	_id: 'password'
	type: 'password'
	required: true
	minLength: 3
	trim: true
]

# Routing config
AccountsTemplates.configureRoute 'signIn',
	redirect: '/profile'
