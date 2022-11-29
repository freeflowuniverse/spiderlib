module view

import net.smtp
import vweb
import time
import rand
import os
import v.ast
import ui_kit { Action, Login }
import crypto.rand as crypto_rand
import sqlite
import freeflowuniverse.crystallib.publisher2 { User }

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

// login page, asks for email, creates cookie with email
['/auth_login']
pub fn (mut app App) login() vweb.Result {
	url := app.get_header('Referer')
	mut route := url.split('//')[1].all_after_first('/')

	if app.get_header('Hx-Request') != 'true' {
		return app.index()
	}

	mut login_action := Action{
		label: 'Continue'
		route: '/auth/email_required'
	}

	login := Login{
		heading: 'Sign in to publisher'
		login: login_action
	}

	return app.html(login.render())
}

// TODO: address based request limits recognition to prevent brute
// TODO: max allowed request per seccond to prevent dos
// sends verification email, returns verify email page
['/auth_verify']
pub fn (mut app App) auth_verify() vweb.Result {
	token := app.get_cookie('token') or { '' }
	user := get_user(token) or { User{} }
	email := user.emails[0].address

	new_auth := send_verification_email(email)
	lock app.authenticators {
		app.authenticators[email] = new_auth
	}

	return $vweb.html()
}

// route of email verification link, random cypher
// authenticates if email/cypher combo correct in 3 tries & 3min
['/authenticate/:email/:cypher'; get]
pub fn (mut app App) authenticate(email string, cypher string) vweb.Result {
	lock app.authenticators {
		if cypher == app.authenticators[email].auth_code.hex() {
			if app.authenticators[email].attempts < 3 {
				$if debug {
					eprintln(@FN + ':\nUser authenticated email: $email')
				}
			}
			app.authenticators[email].authenticated = true
		} else {
			app.authenticators[email].attempts += 1
		}
	}
	return app.text('')
}

pub fn (mut app App) insert_auth_listener() vweb.Result {
	email := app.user.emails[0]
	return app.html('hx-sse="connect:/auth_update/$email"')
}
