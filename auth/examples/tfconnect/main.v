module main

import freeflowuniverse.spiderlib.auth.tfconnect
import json
import vweb

struct TFConnectApp {
	vweb.Context
	vweb.Controller
pub mut:
	user string
}

pub fn (mut app TFConnectApp) index() vweb.Result {
	login_path := '/auth/login'
	user_path := '/user'
	return $vweb.html()
}

['/redirect']
pub fn (mut app TFConnectApp) with_auth() bool {
	// app.user = app.service_get_user() or {
	// 	app.redirect('/auth/login')
    // 	return false
	// }
	app.user = 'test'
	return true
}

pub fn (mut app TFConnectApp) service_get_user() !string {
	return ''
}

[middleware: with_auth]
pub fn (mut app TFConnectApp) user() vweb.Result {
	user := app.user
	println('here: ${user}')
    return app.json(json.encode(user))
}

pub fn (mut app TFConnectApp) not_found() vweb.Result {
    app.set_status(404, 'Not Found')
    return app.html('<h1>Page not found</h1>')
}

fn main() {
	do() or { panic('Failed to run example:\n$err') }
}

fn do() ! {
	authenticator := tfconnect.new(
		public_key: 'test'
		private_key: 'test'
	)!
	auth_controller := tfconnect.new_controller(
		tfconnect: authenticator
		success_url: '/user'
	)!

    mut app := &TFConnectApp{
        controllers: [
            vweb.controller('/auth', &auth_controller),
        ]
    }
    vweb.run(app, 8080)
}