module main

import freeflowuniverse.spiderlib.auth.email
import os
import vweb
import net.smtp
import toml

// Example vweb application with Email Authenticator
struct EmailApp {
	vweb.Context
	vweb.Controller
}

// home page, nothing but an email form that posts input to /login
pub fn (mut app EmailApp) index() vweb.Result {
	verify_path := 'auth/verify_email'
	return $vweb.html()
}

struct EmailForm {
	email string
}

// html returned when verification email is sent
pub fn (mut app EmailApp) verification_sent() vweb.Result {
	return app.html('Verification email sent')
}

pub fn (mut app EmailApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}

fn create_authenticator() email.Authenticator {
	env := toml.parse_file(os.dir(os.dir(@FILE)) + '/.env') or {
		panic('Could not find .env, ${err}')
	}

	client := smtp.Client{
		server: 'smtp-relay.brevo.com'
		from: 'verify@authenticator.io'
		port: 587
		username: env.value('BREVO_SMTP_USERNAME').string()
		password: env.value('BREVO_SMTP_PASSWORD').string()
	}
	return email.Authenticator{
		client: client
		auth_route: 'localhost:8080/auth/authenticate'
	}
}

fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') {
		os.mkdir('${dir}/static')!
	}
	os.chdir('${dir}/static')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')

	// create and run app with authenticator
	mut app := &EmailApp{
		controllers: [
			vweb.controller('/auth', &email.Controller{
				authenticator: create_authenticator()
			}),
		]
	}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run(app, 8080)
}
