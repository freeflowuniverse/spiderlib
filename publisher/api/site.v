module api

import freeflowuniverse.spiderlib.auth.jwt
import freeflowuniverse.spiderlib.publisher.publisher
import vweb
import json
import sync
import freeflowuniverse.spiderlib.api { FunctionCall }


[post]
pub fn (mut app App) get_sites(token string) vweb.Result {

	// sets user from token
	mut user := publisher.User {}
	if jwt.verify_jwt(token) {
		user = jwt.get_user(token) or {panic(err)}
	}

	// sends get_sites function call msg to publisher
	app.channel <- &FunctionCall {
		thread_id: sync.thread_id()
		function: 'get_sites'
		payload: json.encode(user)
	}

	// returns response from function call
	for {
		resp := <- app.response_channel
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	// todo: set timeout
	return app.html('ok')
}

['/get_site/:username/:sitename']
pub fn (mut app App) get_site(username string, sitename string) vweb.Result {

	// // sets user from token
	// mut user := publisher.User {}
	// if jwt.verify_jwt(token) {
	// 	user = jwt.get_user(token) or {panic(err)}
	// }

	// sends get_sites function call msg to publisher
	payload := {
		'username': username
		'sitename': sitename
	} 

	app.channel <- &FunctionCall {
		thread_id: sync.thread_id()
		function: 'get_site'
		payload: json.encode(payload)
	}

	// returns response from function call
	for {
		resp := <- app.response_channel
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	// todo: set timeout
	return app.html('ok')
}