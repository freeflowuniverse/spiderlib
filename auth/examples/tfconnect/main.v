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
pub fn (mut app App) with_auth() bool {
	app.user = tfconnect.service_get_user() or {
		app.redirect('/auth/login')
    	return false
	}
	return true
}

[middleware: with_auth]
pub fn (mut app TFConnectApp) user() vweb.Result {
	user := app.user
    return app.json(json.encode(user))
}

pub fn (mut app TFConnectApp) not_found() vweb.Result {
    app.set_status(404, 'Not Found')
    return app.html('<h1>Page not found</h1>')
}

fn main() {
	auth_controller := tfconnect.new(
		public_key: 'test'
		private_key: 'test'
	)

    mut app := &TFConnectApp{
        controllers: [
            vweb.controller('/auth', &auth_controller),
        ]
    }
    vweb.run(app, 8080)
}