module email

import time
import net.smtp
import vweb
import crypto.rand

// Creates, manages and deals auth sessions
// sessions are indexed by email address 
pub struct Authenticator {
mut:
	sessions map[string]AuthSession
}

// Is initialized when an auth link is sent
// Represents the state of the authentication session
struct AuthSession {
mut:
	timeout       time.Time
	auth_code     string // hex representation of 64 bytes
	attempts_left int  = 3
	authenticated bool = false
}

// creates auth session and random cypher, sends verification link
// returns auth session info
pub fn (mut auth Authenticator) email_verification(email string) AuthSession {
	// for now, the auth code is random 64 bytes
	auth.sessions[email] = AuthSession{}
	auth.send_verification_email(email)
	return auth.sessions[email]
}

// config smtp client and sends mail with verification link
pub fn (mut auth Authenticator) send_verification_email(email string) AuthSession {
	
	// todo: handle attempt limit
	if auth.sessions[email].attempts_left == 0 {
		return auth.sessions[email]
	}

	// update session info
	auth_code := rand.bytes(64) or { panic(err) }
	auth.sessions[email].auth_code = auth_code.hex()
	auth.sessions[email].timeout = time.now().add_seconds(180)
	auth.sessions[email].attempts_left = auth.sessions[email].attempts_left - 1

	// send email with link in body
	// todo: update mail body
	subject := 'Test Subject'
	body := 'Test Body, <a href="localhost:8000/authenticate/$email/${auth_code.hex()}">Click to authenticate</a>'
	// using a mock account from mailtrap to send/receive emails
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

	return auth.sessions[email]
}

// authenticates if email/cypher combo correct within timeout and remaining attemts
// TODO: address based request limits recognition to prevent brute
// TODO: max allowed request per seccond to prevent dos
pub fn (mut auth Authenticator) authenticate(email string, cypher string) AuthSession {
	if auth.sessions[email].attempts_left <= 0 { // checks if remaining attempts
		return auth.sessions[email]
	}

	// authenticates if cypher in link matches authcode
	if cypher == auth.sessions[email].auth_code {
		$if debug {
			eprintln(@FN + ':\nUser authenticated email: $email')
		}
		auth.sessions[email].authenticated = true
	}

	return auth.sessions[email]
}

pub fn (mut auth Authenticator) is_authenticated(email string) bool {
	return auth.sessions[email].authenticated
}
