module main

import os
import freeflowuniverse.spiderlib.auth.session
import freeflowuniverse.spiderlib.auth.email
import vweb
import net.smtp
import net.http
import toml
import log
import json

const port = 8080

// Example vweb application with Email Authenticator
struct AuthenticationApp {
	vweb.Context
	vweb.Controller // session session.Client [vweb_global]
}

// fn create_authenticator() email.Authenticator {
// 	// env := toml.parse_file(os.dir(os.dir(@FILE)) + '/.env') or {
// 	// 	panic('Could not find .env, ${err}')
// 	// }

// 	client := smtp.Client{
// 		server: 'smtp-relay.brevo.com'
// 		from: 'verify@authenticator.io'
// 		port: 587
// 		// username: env.value('BREVO_SMTP_USERNAME').string()
// 		// password: env.value('BREVO_SMTP_PASSWORD').string()
// 	}
// 	return email.Authenticator{
// 		client: client
// 		auth_route: 'localhost:8080/verification_link'
// 	}
// }

fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') {
		os.mkdir('${dir}/static')!
	}
	os.chdir('${dir}/static')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')

	// mut logger := log.Logger(&log.Log{
	// 	level: .debug
	// })

	// mut controller := email.Controller{
	// 	authenticator: create_authenticator()
	// }

	// mut session_ctrl := session.new_controller(&logger)

	// create and run app with authenticator
	mut app := &AuthenticationApp{
		// session: session.Client{'localhost:${port}/session_controller'}
		controllers: [
			// vweb.controller('/email_controller', &controller),
			// vweb.controller('/session_controller', &session_ctrl),
		]
	}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run(app, 8080)
}
