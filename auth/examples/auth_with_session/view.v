module main

import vweb
import freeflowuniverse.spiderlib.htmx
import net.http

// home page, nothing but an email form that posts input to /login
pub fn (mut app AuthenticationApp) index() vweb.Result {
	// htmx for email & tfconnect login
	// email_submit := htmx.form(post_path: '/email_login')
	// tfconnect_click := htmx.navigate(route: '/tfconnect_login')
	return $vweb.html()
}

[POST]
pub fn (mut app AuthenticationApp) email_login() !vweb.Result {
	data := http.parse_form(app.req.data)
	address := data['email']
	session := verify_email(address)!
	if !session.authenticated {
		return app.html('Email verification failed.')
	}
	// note: it is not the recommended to keep user data in jwt's
	// this example only aims to demonstrate session keeping
	refresh_token := app.session.new_refresh_token(address)!
	access_token := app.session.new_access_token(refresh_token)!
	app.set_cookie(name: 'refresh_token', value: refresh_token)
	app.set_cookie(name: 'access_token', value: access_token)
	return app.html('Email ${address} successfully verified!')
}

['/verification_link/:address/:cypher']
pub fn (mut app AuthenticationApp) verification_link(address string, cypher string) !vweb.Result {
	result := authenticate_email(address, cypher)!
	if result.authenticated {
		return app.html('Email ${address} successfully verified!')
	}
	return app.html('Email verification failed.')
}

// html returned when verification email is sent
pub fn (mut app AuthenticationApp) verification_sent() vweb.Result {
	return app.html('Verification email sent')
}

pub fn (mut app AuthenticationApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}
