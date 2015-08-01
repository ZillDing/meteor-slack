# remove the default fields
AccountsTemplates.removeField 'email'
AccountsTemplates.removeField 'password'

# add form fields
AccountsTemplates.addFields [
	_id: 'username'
	type: 'text'
	required: true
	displayName:
		signUp: 'Username (please use lower case letters)'
	minLength: 3
	re: /^\w+$/
	errStr: 'Invalid username. Alphanumeric character (including "_") only.'
	trim: true
	lowercase: true
,
	_id: 'password'
	type: 'password'
	required: true
	minLength: 3
	trim: true
]

AccountsTemplates.configureRoute 'ensureSignedIn',
	template: 'signin'
	layoutTemplate: 'layout'
