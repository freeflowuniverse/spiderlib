module email

import time
import net.smtp
import crypto.rand
import log

// default verification email if another one isn't provided
const default_mail = VerificationEmail {
	from: 'email_authenticator@spiderlib.ff'
	subject: 'Verify your email'
	body: 'Please verify your email by clicking the link below'
}

// Creates and updates, authenticates email authentication sessions
[noinit]
struct Authenticator {
pub:
	client     smtp.Client       [required] // smtp client which will be used to send email
	mail      VerificationEmail = email.default_mail // the mail to be sent with verification. Link is added to the end of the body.
	auth_route string            [required] // route which will handle the authentication link click
mut: 
	sessions map[string]AuthSession // map of active authentication sessions, indexed by email
	logger   &log.Logger
}

// [params]
// struct AuthenticatorConfig {
// 	client smtp.Client [required]

// }

pub fn new(config Authenticator) Authenticator {
	return config
}

pub struct VerificationEmail {
pub:
	from    string
	subject string
	body    string
}

// Is initialized when an auth link is sent
// Represents the state of the authentication session
pub struct AuthSession {
pub mut:
	timeout       time.Time
	auth_code     string // hex representation of 64 bytes
	attempts_left int = 3
	authenticated bool
}

// creates auth session and random cypher, sends verification link
// returns auth session info
pub fn (mut auth Authenticator) email_verification(email string) AuthSession {
	// for now, the auth code is random 64 bytes
	auth.sessions[email] = AuthSession{}
	auth.send_verification_email(email)
	return auth.sessions[email]
}

// sends mail with verification link
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

	mut client := smtp.new_client(auth.client) 
	mail := smtp.Mail{
		to: email
		from: auth.mail.from
		subject: auth.mail.subject
		body_type: .html
		body: '${auth.mail.body}\n<a href="${auth.auth_route}/${email}/${auth_code.hex()}">Click to authenticate</a>'
	}
	// send email with link in body
	client.send(mail) or { panic('Error resolving email address') }
	client.quit() or { panic('Could not close connection to server') }
	auth.logger.debug(@FN + ':\nSent verification email to: ${email}')
	return auth.sessions[email]
}

// result of an authentication attempt
// returns time and attempts remaining
pub struct AttemptResult {
pub:
	authenticated bool
	attempts_left int
	time_left     time.Time
}

// authenticates if email/cypher combo correct within timeout and remaining attemts
// TODO: address based request limits recognition to prevent brute
// TODO: max allowed request per seccond to prevent dos
pub fn (mut auth Authenticator) authenticate(email string, cypher string) !AttemptResult {
	if auth.sessions[email].attempts_left <= 0 { // checks if remaining attempts
		return AttemptResult{
			authenticated: false
			attempts_left: 0
		}
	}

	// authenticates if cypher in link matches authcode
	if cypher == auth.sessions[email].auth_code {
		auth.logger.debug(@FN + ':\nUser authenticated email: ${email}')
		auth.sessions[email].authenticated = true
		result := AttemptResult{
			authenticated: true
			attempts_left: auth.sessions[email].attempts_left
		}
		return result
	} else {
		auth.sessions[email].attempts_left -= 1
		result := AttemptResult{
			authenticated: false
			attempts_left: auth.sessions[email].attempts_left
		}
		return result
	}
	// return auth.sessions[email]
}

// function to check if an email is authenticated
pub fn (mut auth Authenticator) is_authenticated(email string) bool {
	return auth.sessions[email].authenticated
}
