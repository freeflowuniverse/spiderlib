module view

import net.smtp
import vweb
import time
import rand
import os
import v.ast
import crypto.rand as crypto_rand
import freeflowuniverse.crystallib.publisher2
import freeflowuniverse.spiderlib.auth.tfconnect

// email verification page, prompts user to verify email from link sent
// displays remaining time and resend option
['/verify_email']
pub fn (mut app App) verify_email(email string) vweb.Result {
	verify_email := partials.VerifyEmail
	{
		email:
		email
	}
	return app.html(verify_email.html())
}

// login page, asks for email, triggers email verification on form submit
['/login']
pub fn (mut app App) login() vweb.Result {
	mut login_action := Action{
		label: 'Continue'
		route: '/verify_email'
	}

	tfconnect_url := tfconnect.get_login_url(app.get_header('Host'), '8gWG5JzSmBJU+4iGRJc4MCLSs1H3uLstVfwQoSJQWWg=')
	login := Login{
		heading: 'Sign in to publisher'
		login: login_action
		tfconnect_url: tfconnect_url
	}

	return app.html(login.render())
}

pub fn (mut app App) insert_auth_listener() vweb.Result {
	// email := app.user.emails[0]
	// todo
	email := 'å'
	return app.html('hx-sse="connect:/auth_update/${email}"')
}

pub fn (mut app App) tfconnect_failed() vweb.Result {
	return app.html('tfcnonect failed')
}
