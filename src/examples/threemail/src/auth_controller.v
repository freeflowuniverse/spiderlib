module main

import vweb
import net.http
import rand

[params]
pub struct RegisterParams {
	email        string
	tfconnect_id string
}

pub fn (mut app App) register_user(params RegisterParams) string {
	uuid := rand.uuid_v4()
	lock app.users {
		app.users[uuid] = User{
			uuid: uuid
			email: params.email
		}
	}
	return uuid
}

pub fn (mut app App) save_session(id string) ! {
	refresh_token := app.session_client.new_refresh_token(
		uuid: id
		issuer: 'me'
	)!
	access_token := app.session_client.new_access_token(
		refresh_token: refresh_token
	)!
	app.set_cookie(
		name: 'refresh_token'
		value: refresh_token
		path: '/'
	)
	app.set_cookie(
		name: 'access_token'
		value: access_token
		path: '/'
	)
}
