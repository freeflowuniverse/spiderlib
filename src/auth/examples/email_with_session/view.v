module main

import vweb
import net.http

const agent = 'Email Authentication App'

// home page, nothing but an email form that posts input to /login
[middleware: get_user]
pub fn (mut app EmailApp) index() vweb.Result {
	user := app.get_value[string]('user') or { 'No current user session' }
	verify_path := 'send_verification_email'
	return $vweb.html()
}

[POST]
pub fn (mut app EmailApp) send_verification_email() !vweb.Result {
	app.logger.debug('${agent}: form post received to verify email')
	data := http.parse_form(app.req.data)
	address := data['email']
	session := app.email_client.send_verification_email(address) or { panic('here:${err}') }
	success := '<div hx-get="" hx-trigger="every 2s">
	Verification email sent!
	</div>'
	return app.html('${session}')
}

[POST]
pub fn (mut app EmailApp) email_is_verified() !vweb.Result {
	app.logger.debug('${agent}: form post received to verify email')
	data := http.parse_form(app.req.data)
	address := data['email']
	session := app.email_client.send_verification_email(address)!
	if !session.authenticated {
		return app.html('Email verification failed.')
	}
	// note: it is not the recommended to keep user data in jwt's
	// this example only aims to demonstrate session keeping
	refresh_token := app.session_client.new_refresh_token(address)!
	access_token := app.session_client.new_access_token(refresh_token)!
	app.set_cookie(name: 'refresh_token', value: refresh_token)
	app.set_cookie(name: 'access_token', value: access_token)
	return app.html('Email ${address} successfully verified!')
}

['/verification_link/:address/:cypher']
pub fn (mut app EmailApp) verification_link(address string, cypher string) !vweb.Result {
	result := app.email_client.authenticate(address, cypher)!
	if result.authenticated {
		return app.html('Email ${address} successfully verified!')
	}
	return app.html('Email verification failed.')
}

pub fn (mut app EmailApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}
