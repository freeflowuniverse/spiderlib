module main

import freeflowuniverse.spiderlib.auth.tfconnect
import json
import vweb

struct TFConnectApp {
	vweb.Context
	authenticator tfconnect.TFConnect [vweb_global]
}

pub fn (mut app TFConnectApp) index() vweb.Result {
	login_path := '/login'
	return $vweb.html()
}

['/login']
pub fn (mut app TFConnectApp) login() !vweb.Result {
	login_url := app.authenticator.create_login_url()
	return app.redirect(login_url)
}

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

pub fn (mut app TFConnectApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}

fn main() {
	do() or { panic('Failed to run example:\n${err}') }
}

fn do() ! {
	authenticator := tfconnect.new(
		app_id: 'localhost:8080'
		callback: '/callback'
		scopes: tfconnect.Scopes{
			email: true
		}
	)!
	mut app := &TFConnectApp{
		authenticator: authenticator
	}
	vweb.run(app, 8080)
}
