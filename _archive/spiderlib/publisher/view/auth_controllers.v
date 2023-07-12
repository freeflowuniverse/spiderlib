module view

import crypto.hmac
import crypto.sha256
import crypto.bcrypt
import encoding.base64
import json
import rand
import vweb.sse { SSEMessage }
import time
import freeflowuniverse.spiderlib.auth.tfconnect
import net.smtp
import net.http
import crypto.rand as crypto_rand
import os
import freeflowuniverse.spiderlib.publisher.publisher { User }
import freeflowuniverse.spiderlib.auth.jwt
import freeflowuniverse.spiderlib.cookies
import vweb

// email verification controller, initiates email verification,
// sends verification link, and returns verify email page
[post]
pub fn (mut app App) email_verification(email string) vweb.Result {
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})
	data := {
		'email': email
	}

	// todo: add authorization header
	request := http.Request{
		url: 'http://localhost:8002/email_verification'
		method: http.Method.post
		header: header
		data: json.encode(data)
	}
	response := request.do() or {
		panic('Could not send verify email request to authorization server: $err')
	}
	println('resp: $response')

	return app.verify_email(email) // returns email verification view
}

// triggered when email is verified
// gets user from publisher api
// creates / updates jwt cookie, redirects to callback
[post]
pub fn (mut app App) callback_email(email string) vweb.Result {
	// app.username = user.name
	// token := jwt.create_token(user.name)
	// app.set_cookie(name: 'token', value: token)

	// // api post to get user
	// header := http.new_header_from_map({
	// 	http.CommonHeader.content_type: 'application/json',
	// })

	// request := http.Request{
	// 	url: "http://localhost:8080/get_user"
	// 	method: http.Method.post
	// 	header: header,
	// 	data: json.encode(user),
	// }

	// result := request.do()!
	// user := json.decode(User, result.body) or {panic('cannot decode: $err')}
	// access_token := app.get_access_token(user)
	// app.set_cookie(name: 'access_token', value: access_token)

	return app.html('/')
}

// // requests an access token for a user from the authorization server api
// fn (mut app App) get_access_token(user User) !string {

// 	header := http.new_header_from_map({
// 		http.CommonHeader.content_type: 'application/json',
// 	})
// 	data := {
// 		'name': user.name
// 		'emails': user.emails
// 	}

// 	// todo: add authorization header
// 	request := http.Request{
// 		url: "http://localhost:8080/create_access_token"
// 		method: http.Method.post
// 		header: header,
// 		data: json.encode(data),
// 	}
// 	access_token := request.do() or {
// 		return error('Could not get access token from authorization server: $err')
// 	}
// 	return access_token
// }

// Updates authentication status by sending server sent event
['/auth_update/:email']
pub fn (mut app App) auth_update(email string) vweb.Result {
	mut session := sse.new_connection(app.conn)
	session.start() or { return app.server_error(501) }

	$if debug {
		eprintln(@FN + ':\nWaiting authentication for email: $email')
	}

	// checks if email is authenticated every 2 seconds
	// inspired from https://github.com/vlang/v/blob/master/examples/vweb/server_sent_events/server.v
	// todo: implement email auth api with websockets
	mut first := true
	for {
		header := http.new_header_from_map({
			http.CommonHeader.content_type: 'application/json'
		})
		data := {
			'email': email
		}

		// todo: add authorization header
		request := http.Request{
			url: 'http://localhost:8002/is_authenticated'
			method: http.Method.post
			header: header
			data: json.encode(data)
		}
		response := request.do() or {
			panic('Could not send verify email request to authorization server: $err')
		}
		if response.body == 'true' && first {
			sse_data := '{"time": "$time.now().str()", "random_id": "$rand.ulid()"}'
			//? for some reason htmx doesn't pick up first sse
			msg := SSEMessage{
				event: 'email_authenticated'
				data: sse_data
			}
			session.send_message(msg) or { return app.server_error(501) }
			session.send_message(msg) or { return app.server_error(501) }
			first = false
		}
		time.sleep(2 * time.second)
	}

	return app.server_error(501)
}

['/callback']
pub fn (mut app App) callback_tfconnect() vweb.Result {
	println('call')
	// gets tfconnect response

	// data := SignedAttempt{}
	// initial_data := data.load(app.query.clone())!
	println('query: ${app.query.clone()}')

	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})

	// todo: add authorization header
	request := http.Request{
		url: 'http://localhost:8002/login/tfconnect'
		method: http.Method.post
		header: header
		data: json.encode(app.query.clone())
	}
	
	// sets app username to received access token issuer
	response := request.do() or { 
		panic('Failed to send login request to api: $err') 
	}
	payload := jwt.get_payload(response.body) or {
		panic('Failed to get payload from jwt: $err')
	}
	app.username = payload.iss

	// secure approach to keeping session inspired from:
	// https://stackoverflow.com/questions/244882/what-is-the-best-way-to-implement-remember-me-for-a-website
	cookie := cookies.LoginCookie {
		identifier: payload.sub
		token: payload.data
	}
	app.set_cookie(name: 'login_cookie', value: 'cookie')

	return app.html('ok')
}
