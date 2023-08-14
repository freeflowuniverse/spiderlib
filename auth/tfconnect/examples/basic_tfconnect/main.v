module main

import freeflowuniverse.spiderlib.auth.tfconnect
import json
import vweb

// Example vweb application with TFConnect Authenticator
struct TFConnectApp {
	vweb.Context
	authenticator tfconnect.TFConnect [vweb_global]
}

// home page, nothing but a button that routes to /login
pub fn (mut app TFConnectApp) index() vweb.Result {
	login_path := '/login'
	return $vweb.html()
}

// login route, creates new tfconnect login url and redirects to it
['/login']
pub fn (mut app TFConnectApp) login() !vweb.Result {
	login_url := app.authenticator.create_login_url()
	return app.redirect(login_url)
}

// callback route from TFConnect authentication attempt, decodes and verifies sign attempt
pub fn (mut app TFConnectApp) callback() vweb.Result {
	query := app.query.clone()
	signed_attempt := tfconnect.load_signed_attempt(query) or {
		app.error('Could not load signed tfconnect login attempt')
		return app.server_error(400)
	}
	res := app.authenticator.verify(signed_attempt) or {
		app.error('Could not verify signed tfconnect login attempt')
		return app.server_error(400)
	}
	return app.json(json.encode(res))
}

// 404 page
pub fn (mut app TFConnectApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}

fn main() {
	do() or { panic('Failed to run example:\n${err}') }
}

fn do() ! {
	// create authenticator with correct configuration
	authenticator := tfconnect.new(
		app_id: 'localhost:8080'
		callback: '/callback'
		scopes: tfconnect.Scopes{
			email: true // request email scope
		}
	)!

	// create and run app with authenticator
	mut app := &TFConnectApp{
		authenticator: authenticator
	}
	vweb.run(app, 8080)
}
