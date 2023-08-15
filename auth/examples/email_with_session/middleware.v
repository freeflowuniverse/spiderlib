module main

import freeflowuniverse.spiderlib.auth.jwt

pub fn (mut app EmailApp) get_user() bool {
	mut access_token_str := app.get_cookie('access_token') or { return true }
	access_token := jwt.SignedJWT(access_token_str).decode() or { panic(err) }
	if access_token.is_expired() {
		refresh_token_str := app.get_cookie('refresh_token') or { '' }
		access_token_str = app.session_client.new_access_token(refresh_token_str) or { panic(err) }
		app.set_cookie(name: 'access_token', value: access_token_str)
	}
	app.session_client.authenticate_access_token(access_token_str) or { panic(err) }
	subject := jwt.SignedJWT(access_token_str).decode_subject() or { panic(err) }
	app.set_value('user', subject)
	return true
}
