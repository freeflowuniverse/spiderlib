module main

import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session
import os
import vweb
import net.smtp
import log
import toml

const port = 8080

const host = 'http://localhost:${port}'

// Example vweb application with Email Authenticator
struct EmailApp {
	vweb.Context
	vweb.Controller
	email_client   email.Client   [vweb_global]
	session_client session.Client [vweb_global]
mut:
	logger &log.Logger [vweb_global]
}

fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') {
		os.mkdir('${dir}/static')!
	}
	os.chdir('${dir}/static')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')

	mut logger := log.Logger(&log.Log{
		level: .debug
	})

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

	mut email_ctrl := email.new_controller(
		logger: &logger
		authenticator: email.Authenticator{
			logger: &logger
			client: client
			auth_route: '${host}/verification_link'
		}
	)

	mut session_ctrl := session.new_controller(&logger)

	// create and run app with authenticator
	mut app := &EmailApp{
		email_client: email.Client{'${host}/email_controller'}
		session_client: session.Client{'${host}/session_controller'}
		logger: &logger
		controllers: [
			vweb.controller('/email_controller', &email_ctrl),
			vweb.controller('/session_controller', &session_ctrl),
		]
	}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run(app, port)
}
