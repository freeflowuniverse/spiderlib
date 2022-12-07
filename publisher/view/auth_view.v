module view

import net.smtp
import vweb
import time
import rand
import os
import v.ast
import uikit.partials { Action, Login }
import crypto.rand as crypto_rand
import sqlite
import freeflowuniverse.crystallib.publisher2 { User }
import freeflowuniverse.spiderlib.auth.tfconnect

// Root auth route, handles login, verification, and redirect
['/auth/:requisite']
pub fn (mut app App) auth(requisite string) vweb.Result {
	url := app.get_header('Referer')
	mut route := url.split('//')[1].all_after_first('/')
	mut satisfied := false

	if requisite == 'email_required' {
		if app.user.emails.len == 0 {
			route = '/auth_login'
		} else {
			satisfied = true
		}
	}

	if requisite == 'auth_required' {
		if app.user.emails.any(!it.authenticated) {
			route = '/auth_verify'
		} else {
			satisfied = true
		}
	}

	// Redirect (via hx-location) to route if requisite satisfed
	if satisfied {
		target := app.get_header('Hx-Target')
		if target != '' {
			app.add_header('HX-Location', '{"path":"/$route", "target":"#$target"}')
		} else {
			app.add_header('HX-Location', '{"path":"/$route"}')
		}
		return app.ok('')
	}

	return $vweb.html()
}

// // Email verification page with sse listener
// // redirects to callback when email is verified
// ['/verify_email/:email']
// pub fn (mut app App) verify_email(email string) vweb.Result {
// 	verify_email := app.ui.verify_email_partial(email)
// 	return app.html(verify_email.html())
// }

// email verification page, prompts user to verify email from link sent
// displays remaining time and resend option
['/verify_email']
pub fn (mut app App) verify_email(email string) vweb.Result {
	verify_email := partials.VerifyEmail {
		email: email
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

// // TODO: address based request limits recognition to prevent brute
// // TODO: max allowed request per seccond to prevent dos
// // sends verification email, returns verify email page
// ['/auth_verify']
// pub fn (mut app App) auth_verify() vweb.Result {
// 	token := app.get_cookie('token') or { '' }
// 	user := get_user(token) or { User{} }
// 	email := user.emails[0].address

// 	new_auth := send_verification_email(email)
// 	lock app.authenticators {
// 		app.authenticators[email] = new_auth
// 	}

// 	return $vweb.html()
// }

pub fn (mut app App) insert_auth_listener() vweb.Result {
	email := app.user.emails[0]
	return app.html('hx-sse="connect:/auth_update/$email"')
}

pub fn (mut app App) tfconnect_failed() vweb.Result {
	return app.html('tfcnonect failed')
}