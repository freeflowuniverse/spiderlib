module main

import vweb
import time
import os
import json
import x.json2
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }
import freeflowuniverse.spiderlib.auth.email { Authenticator }

const (
	port = 8002
)

// pub fn (mut app App) before_request() {
// 	// hx_request := app.get_header('Hx-Request') == 'true'
// 	// if !hx_request && app.req.url != '/' && app.req.url.ends_with('.html') && !app.req.url.starts_with('/sites/') && !app.req.url.starts_with('/testsite/') {
// 	// 	app.redirect('')
// 	// }
// 	// // updates app user before each request
// 	// token := app.get_cookie('token') or { '' }
// 	// app.user = get_user(token) or { User{} }
// }

struct App {
	vweb.Context
mut:
	channel          chan &FunctionCall     [vweb_global]
	response_channel chan &FunctionResponse [vweb_global]
}

pub fn new_app() &App {
	mut app := &App{
		channel: chan &FunctionCall{cap: 100}
		response_channel: chan &FunctionResponse{cap: 100}
	}
	return app
}

pub fn (mut app App) index() vweb.Result {
	return app.html('')
}

pub fn main() {
	mut authenticator := Authenticator{}
	mut api := new_app()
	go vweb.run(api, port)

	for {
		call := <-api.channel
		mut response := ''

		match call.function {
			// 'send_link' {
			// 	email_address := call.payload
			// 	sent := authenticator.send_link(email_address) or {
			// 		panic(err)
			// 	}
			// 	if sent {
			// 		response = 'email_sent'
			// 	} else {}
			// }
			// 'verify_email' {
			// 	token := json.decode(Token, call.payload)!
			// 	verified := publisher.get_sites(user) or {
			// 		panic(err)
			// 	}
			// 	response = json.encode(sites)
			// }
			'email_verification' {
				email := call.payload
				auth_session := authenticator.email_verification(email)
				response = json.encode(auth_session)
			}
			'is_authenticated' {
				email := call.payload
				is_authenticated := authenticator.is_authenticated(email)
				response = json.encode(is_authenticated)
			}
			'authenticate' {
				data_ := json2.raw_decode(call.payload) or { panic(err) }
				email := data_.as_map()['email']!.str()
				cypher := data_.as_map()['cypher']!.str()
				auth_session := authenticator.authenticate(email, cypher)
				response = json.encode(auth_session)
			}
			else {}
		}
		api.response_channel <- &FunctionResponse{
			thread_id: call.thread_id
			function: call.function
			payload: response
		}
	}
}
