module view

import crypto.hmac
import crypto.sha256
import crypto.bcrypt
import encoding.base64
import json
import rand
import vweb.sse { SSEMessage }
import time
import net.smtp
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

// create authenticator and random cypher
// config smtp client and sends mail with verification link
fn send_verification_email(email string) Auth {
	auth_code := crypto_rand.bytes(64) or { panic(err) }
	authenticator := Auth { auth_code: auth_code }

	auth_hex := auth_code.hex()
	expiry_unix := time.now().unix + 180
	timeout := time.new_time(unix: expiry_unix)

	subject := 'Test Subject'
	body := 'Test Body, <a href="localhost:8000/authenticate/$email/$auth_hex">Click to authenticate</a>'
	client_cfg := smtp.Client {
		server: 'smtp.mailtrap.io'
		from: 'verify@tfpublisher.io'
		port: 465
		username: 'e57312ae7c9742'
		password: 'b8dc875d4a0b33'
	}
	send_cfg := smtp.Mail{
		to: email
		subject: subject
		body_type: .html
		body: body
	}
	mut client := smtp.new_client(client_cfg) or { panic('Error creating smtp client: $err') }
	client.send(send_cfg) or { panic('Error resolving email address') }
	client.quit() or { panic('Could not close connection to server')}
	$if debug {
		eprintln(@FN + ':\nSent verification email to: $email')
	}
	return authenticator
}

// create login cookie and add user to publisher
[post]
pub fn (mut app App) login_service(email string) vweb.Result {
	email_obj := Email {
		address: email
		authenticated: false
	}
	user := User { name: email, emails: [email_obj] }
	lock app.publisher{
		if app.publisher.users[email] == User{} {
			mut new_user := app.publisher.user_add(email)
			new_user.emails = [email_obj]
		}
	}
	token := make_token(user)
	app.set_cookie(name: 'token', value: token)
	return app.ok('')
}

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
	for {
		lock app.authenticators{
			if app.authenticators[email].authenticated {
				data := '{"time": "$time.now().str()", "random_id": "$rand.ulid()"}'
				//? for some reason htmx doesn't pick up first sse
				msg := SSEMessage{event: 'email_authenticated', data: data}
				session.send_message(msg) or { return app.server_error(501) }
				session.send_message(msg) or { return app.server_error(501) }
				app.authenticators[email].authenticated = false
			}
		}
		time.sleep(2 * time.second)
	}

	return app.server_error(501)
}
