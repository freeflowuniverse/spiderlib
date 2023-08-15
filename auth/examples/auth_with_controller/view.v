module main

import vweb
import net.http

[POST]
pub fn (mut app EmailApp) verify_email() !vweb.Result {
	data := http.parse_form(app.req.data)
	address := data['email']
	session := app.client.verify_email(address)!
	if session.authenticated {
		return app.html('Email ${address} successfully verified!')
	}
	return app.html('Email verification failed.')
}

['/verification_link/:address/:cypher']
pub fn (mut app EmailApp) verification_link(address string, cypher string) !vweb.Result {
	result := app.client.authenticate(address, cypher)!
	if result.authenticated {
		return app.html('Email ${address} successfully verified!')
	}
	return app.html('Email verification failed.')
}

// html returned when verification email is sent
pub fn (mut app EmailApp) verification_sent() vweb.Result {
	return app.html('Verification email sent')
}

pub fn (mut app EmailApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}
