module main

import freeflowuniverse.spiderlib.auth.email
import os
import vweb
import net.smtp
import net.http
import toml
import json

// Example vweb application with Email Authenticator
struct EmailApp {
	vweb.Context
	vweb.Controller
	client email.Client
}

// home page, nothing but an email form that posts input to /login
pub fn (mut app EmailApp) index() vweb.Result {
	verify_path := 'verify_email'
	return $vweb.html()
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
		auth_route: 'localhost:8080/verification_link'
	}
}

fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') {
		os.mkdir('${dir}/static')!
	}
	os.chdir('${dir}/static')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')

	mut controller := email.Controller{
		authenticator: create_authenticator()
	}

	// create and run app with authenticator
	mut app := &EmailApp{
		client: email.Client{
			url: 'localhost:8080/email_controller'
		}
		controllers: [
			vweb.controller('/email_controller', &controller),
		]
	}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run(app, 8080)
}
