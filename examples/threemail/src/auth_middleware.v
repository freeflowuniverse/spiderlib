module main

import freeflowuniverse.spiderlib.auth.jwt

pub fn (mut app App) get_user() bool {
	app.logger.debug('Running middleware with user')
	mut access_token_str := app.get_cookie('access_token') or {
		app.logger.debug('Access token coookie not found.')
		return true
	}
	access_token := jwt.SignedJWT(access_token_str).decode() or {
		app.logger.error('Failed to decode user\'s access token: ${err}')
		return true
	}
	if access_token.is_expired() {
		app.logger.debug('Access token is expired, fetching new access token.')
		refresh_token_str := app.get_cookie('refresh_token') or {
			app.logger.error('Refresh token cookie not found.')
			return true
		}
		refresh_token := jwt.SignedJWT(refresh_token_str).decode() or {
			app.logger.error('Failed to decode user\'s refresh token: ${err}')
			return true
		}
		if refresh_token.is_expired() {
			app.logger.debug('Refresh token is expired, user must authenticate to create new session')
			return true
		}
		println('req')
		access_token_str = app.session_client.new_access_token(refresh_token: refresh_token_str) or {
			app.logger.error('Failed to create new access token: ${err}')
			return true
		}
		app.set_cookie(name: 'access_token', value: access_token_str)
	}
	app.session_client.authenticate_access_token(access_token_str) or {
		app.logger.error('Failed to authenticate access token: ${err}')
		return true
	}
	subject := jwt.SignedJWT(access_token_str).decode_subject() or {
		app.logger.error('Failed to fetch user id from access token: ${err}')
		return true
	}
	app.set_value('user_id', subject)
	rlock app.users {
		app.set_value('user', app.users[subject])
	}
	return true
}

pub fn (mut app App) with_user() bool {
	app.logger.debug('Running middleware with user')
	mut access_token_str := app.get_cookie('access_token') or {
		app.logger.debug('Access token coookie not found.')
		app.login()
		return true
	}
	access_token := jwt.SignedJWT(access_token_str).decode() or {
		app.logger.error('Failed to decode user\'s access token: ${err}')
		return true
	}
	if access_token.is_expired() {
		app.logger.debug('Access token is expired, fetching new access token.')
		refresh_token_str := app.get_cookie('refresh_token') or {
			app.logger.error('Refresh token cookie not found.')
			return true
		}
		refresh_token := jwt.SignedJWT(refresh_token_str).decode() or {
			app.logger.error('Failed to decode user\'s refresh token: ${err}')
			return true
		}
		if refresh_token.is_expired() {
			app.logger.debug('Refresh token is expired, user must authenticate to create new session')
			app.login()
			return true
		}
		access_token_str = app.session_client.new_access_token(refresh_token: refresh_token_str) or {
			app.logger.error('Failed to create new access token: ${err}')
			return true
		}
		app.set_cookie(name: 'access_token', value: access_token_str)
	}
	app.session_client.authenticate_access_token(access_token_str) or {
		app.logger.error('Failed to authenticate access token: ${err}')
		return true
	}
	subject := jwt.SignedJWT(access_token_str).decode_subject() or {
		app.logger.error('Failed to fetch user id from access token: ${err}')
		return true
	}
	app.set_value('user_id', subject)
	rlock app.users {
		app.set_value('user', app.users[subject])
	}
	return true
}

pub fn (mut app App) with_access_token() bool {
	app.logger.debug('Running middleware with user')
	mut access_token_str := app.get_cookie('access_token') or {
		app.logger.debug('Access token coookie not found.')
		app.login()
		return false
	}
	access_token := jwt.SignedJWT(access_token_str).decode() or {
		app.logger.error('Failed to decode user\'s access token: ${err}')
		return true
	}
	if access_token.is_expired() {
		app.logger.debug('Access token is expired, fetching new access token.')
		refresh_token_str := app.get_cookie('refresh_token') or {
			app.logger.error('Refresh token cookie not found.')
			return true
		}
		refresh_token := jwt.SignedJWT(refresh_token_str).decode() or {
			app.logger.error('Failed to decode user\'s refresh token: ${err}')
			return true
		}
		if refresh_token.is_expired() {
			app.logger.debug('Refresh token is expired, user must authenticate to create new session')
			app.login()
			return false
		}
		access_token_str = app.session_client.new_access_token(refresh_token: refresh_token_str) or {
			app.logger.error('Failed to create new access token: ${err}')
			return true
		}
		app.set_cookie(name: 'access_token', value: access_token_str)
	}
	app.set_value('access_token', access_token_str)
	return true
}

// fn get_session(mut ctx vweb.Context) bool {
//    mut access_token_str := app.get_cookie('access_token') or { return true }
// 	access_token := jwt.SignedJWT(access_token_str).decode() or { panic(err) }
// 	if access_token.is_expired() {
// 		refresh_token_str := app.get_cookie('refresh_token') or { '' }
// 		access_token_str = app.session_client.new_access_token(refresh_token: refresh_token_str) or { panic(err) }
// 		app.set_cookie(name: 'access_token', value: access_token_str)
// 	}
// 	app.session_client.authenticate_access_token(access_token_str) or { panic(err) }
// 	subject := jwt.SignedJWT(access_token_str).decode_subject() or { panic(err) }
// 	app.set_value('user_id', subject)
// 	return true
// }
