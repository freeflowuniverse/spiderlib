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
import freeflowuniverse.crystallib.publisher2 { Publisher, User, Email, Access }
import vweb

// JWT code in this page is from 
// https://github.com/vlang/v/blob/master/examples/vweb_orm_jwt/src/auth_services.v
// credit to https://github.com/enghitalo

struct JwtHeader {
	alg string
	typ string
}

//TODO: refactor to use single JWT interface
struct JwtPayload {
	sub         string    // (subject)
	iss         string    // (issuer)
	exp         string    // (expiration)
	iat         time.Time // (issued at)
	aud         string    // (audience)
	user		User
}

struct AccessPayload {
	sub         string  
	iss         string  
	exp         string  
	iat         time.Time
	aud         string  
	access		Access
	user		string
}

// creates user jwt cookie, enables session keeping
fn make_token(user User) string {
	
	$if debug {
		eprintln(@FN + ':\nCreating cookie token for user: $user')
	}	

	secret := os.getenv('SECRET_KEY')
	jwt_header := JwtHeader{'HS256', 'JWT'}
	jwt_payload := JwtPayload{
		user: user
		iat: time.now()
	}

	header := base64.url_encode(json.encode(jwt_header).bytes())
	payload := base64.url_encode(json.encode(jwt_payload).bytes())
	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.$payload'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	jwt := '${header}.${payload}.$signature'

	return jwt
}

// creates site access token
// used to cache site accesses within session
// TODO: must expire within session in case access revoked
fn make_access_token(access Access, user string) string {
	
	$if debug {
		eprintln(@FN + ':\nCreating access cookie for user: $user')
	}	

	secret := os.getenv('SECRET_KEY')
	jwt_header := JwtHeader{'HS256', 'JWT'}
	jwt_payload := AccessPayload{
		access: access
		user: user
		iat: time.now()
	}

	header := base64.url_encode(json.encode(jwt_header).bytes())
	payload := base64.url_encode(json.encode(jwt_payload).bytes())
	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.$payload'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	jwt := '${header}.${payload}.$signature'

	return jwt
}

// verifies jwt cookie 
fn auth_verify(token string) bool {
	secret := os.getenv('SECRET_KEY')
	token_split := token.split('.')

	signature_mirror := hmac.new(secret.bytes(), '${token_split[0]}.${token_split[1]}'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes()

	signature_from_token := base64.url_decode(token_split[2])

	return hmac.equal(signature_from_token, signature_mirror)
}

// gets cookie token, returns user obj
fn get_user(token string) ?User {
	if token == '' {
		return error('Cookie token is empty')
	}
	payload := json.decode(JwtPayload, base64.url_decode(token.split('.')[1]).bytestr()) or {
		panic(err)
	}
	return payload.user
}

// gets cookie token, returns access obj
fn get_access(token string, username string) ?Access {
	if token == '' {
		return error('Cookie token is empty')
	}
	payload := json.decode(AccessPayload, base64.url_decode(token.split('.')[1]).bytestr()) or {
		panic(err)
	}
	if payload.user != username {
		return error('Access cookie is for different user')
	}
	return payload.access
}

// email verification controller, initiates email verification,
// sends verification link, and returns verify email page
[post]
pub fn (mut app App) email_verification(email string) vweb.Result {
	
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json',
	})
	data := {'email': email}

	// todo: add authorization header
	request := http.Request{
		url: "http://localhost:8002/email_verification"
		method: http.Method.post
		header: header,
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
pub fn (mut app App) email_login(email string) vweb.Result {
	email_obj := Email {
		address: email
		authenticated: true
	}

	user := User { name: email, emails: [email_obj] }
	app.user = user
	token := make_token(user)
	app.set_cookie(name: 'token', value: token)

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
["/auth_update/:email"]
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
			http.CommonHeader.content_type: 'application/json',
		})
		data := {'email': email}

		// todo: add authorization header
		request := http.Request{
			url: "http://localhost:8002/is_authenticated"
			method: http.Method.post
			header: header,
			data: json.encode(data)
		}
		response := request.do() or {
			panic('Could not send verify email request to authorization server: $err')
		}
		if response.body == 'true' && first {
			sse_data := '{"time": "$time.now().str()", "random_id": "$rand.ulid()"}'
			//? for some reason htmx doesn't pick up first sse
			msg := SSEMessage{event: 'email_authenticated', data: sse_data}
			session.send_message(msg) or { return app.server_error(501) }
			session.send_message(msg) or { return app.server_error(501) }
			first = false
		}
		time.sleep(2 * time.second)
	}

	return app.server_error(501)
}

struct TFConnectResponse {
	email string
	identifier string
}

["/callback"]
pub fn (mut app App) callback() vweb.Result {
	// gets tfconnect response
	resp := tfconnect.callback(app.query.clone()) or { panic(err) }

	response := json.decode(TFConnectResponse, resp) or {
		panic('cannot decode resp')
	}

	user := User {
		name: response.identifier
		emails: [Email {address: response.email,authenticated: true}]
	}
	app.user = user
	token := make_token(user)
	app.set_cookie(name: 'token', value: token)

	app.redirect('/')
	return app.html('ok')
}