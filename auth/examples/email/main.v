module main

import freeflowuniverse.spiderlib.auth.email
import net.http
import os
import vweb
import time
import toml
import net.smtp

// Example vweb application with Email Authenticator
struct EmailApp {
	vweb.Context
	authenticator shared email.Authenticator
}

// home page, nothing but an email form that posts input to /login
pub fn (mut app EmailApp) index() vweb.Result {
	verify_path := '/verify_email'
	return $vweb.html()
}

struct EmailForm {
	email string
}

// login route, sends verification email to the input posted, returns status message
[POST]
pub fn (mut app EmailApp) verify_email() !vweb.Result {
	data := http.parse_form(app.req.data)
	address := data['email']
	lock app.authenticator {
		_ := app.authenticator.email_verification(data['email'])
	}

	// checks if email verified every 2 seconds
	for {
		lock app.authenticator {
			if app.authenticator.is_authenticated(address) {
				// returns success message once verified
				return app.html('Email ${address} has been verified')
			}
		}
		time.sleep(2 * time.second)
	}
	return app.html('timeout')
}

// html returned when verification email is sent
pub fn (mut app EmailApp) verification_sent() vweb.Result {
	return app.html('Verification email sent')
}

['/authenticate/:address/:cypher']
pub fn (mut app EmailApp) authenticate(address string, cypher string) vweb.Result {
	lock app.authenticator {
		app.authenticator.authenticate(address, cypher)
	}
	return app.html('Email verified')
}

pub fn (mut app EmailApp) not_found() vweb.Result {
	app.set_status(404, 'Not Found')
	return app.html('<h1>Page not found</h1>')
}

fn create_authenticator() email.Authenticator {
	env := toml.parse_file(os.dir(os.dir(@FILE)) + '/.env') or {
		panic('Could not find .env, ${err}')
	}
	println('here: ${env}')
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
		authenticator: create_authenticator()
	}
	app.mount_static_folder_at('${dir}/static', '/static')

	vweb.run(app, 8080)
}
