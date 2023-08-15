module main

import freeflowuniverse.spiderlib.spider
import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session
import freeflowuniverse.spiderlib.auth.tfconnect
import net.smtp
import toml
import vweb
import log
import os

const port = 8080

const host = 'http://localhost:${port}'

const root = os.dir(os.dir(@FILE))

// configures email authentication controller with verification route
// provides smtp client to send verification email
pub fn create_email_controller() email.Controller {
	env := toml.parse_file('${root}/.env') or { panic('Could not find .env, ${err}') }

	client := smtp.Client{
		server: 'smtp-relay.brevo.com'
		from: 'verify@authenticator.io'
		port: 587
		username: env.value('BREVO_SMTP_USERNAME').string()
		password: env.value('BREVO_SMTP_PASSWORD').string()
	}

	return email.Controller{
		authenticator: email.Authenticator{
			client: client
			// route in app which will verify clicked link
			auth_route: 'http://localhost:8080/verification_link'
		}
	}
}

pub fn main() {
	mut logger := log.Logger(&log.Log{
		level: .debug
	})
	mut email_client := email.Client{'${host}/email_controller'}
	mut session_client := session.Client{'${host}/session_controller'}
	mut tfconnect_client := session.Client{'${host}/tfconnect_controller'}
	mut email_ctrl := create_email_controller()
	mut session_ctrl := session.new_controller(&logger)
	mut tfconnect_ctrl := tfconnect.new_controller(
		tfconnect: tfconnect.new(
			app_id: host
		)!
	)!

	web := spider.load(root)!
	web.install()!
	web.precompile()! // tailwind precompilation

	mut app := App{
		logger: &logger
		email_client: email_client
		session_client: session_client
		controllers: [
			vweb.controller('/email_controller', &email_ctrl),
			vweb.controller('/session_controller', &session_ctrl),
		]
	}

	app.mount_static_folder_at('${root}/src/static', '/static')
	vweb.run[App](app, 8080)
}
