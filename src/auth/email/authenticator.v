module email

import time
import net.smtp
import crypto.hmac
import crypto.sha256
import crypto.rand
import encoding.hex
import log

// Creates and updates, authenticates email authentication sessions
[noinit]
pub struct Authenticator {
	secret string
mut: // route which will handle the authentication link click
	backend IBackend
	logger   &log.Logger = &log.Logger(&log.Log{
		level: .info
	})
}

// Is initialized when an auth link is sent
// Represents the state of the authentication session
pub struct AuthSession {
pub mut:
	email		string
	timeout       time.Time
	auth_code     string // hex representation of 64 bytes
	attempts_left int = 3
	authenticated bool
}

[params]
pub struct AuthenticatorConfig {
	secret string
	backend IBackend
	logger &log.Logger = &log.Logger(&log.Log{
		level: .debug
	})
}

pub fn new(config AuthenticatorConfig) Authenticator {
	return Authenticator {
		backend: config.backend
		logger: config.logger
		secret: config.secret
	}
}

[params]
pub struct SendMailConfig {
	email string
	mail VerificationMail
	smtp SmtpConfig [required]
	link string [required]
}

pub struct VerificationMail {
pub:
	from    string = 'email_authenticator@spiderlib.ff'
	subject string = 'Verify your email'
	body    string = 'Please verify your email by clicking the link below'
}

pub struct SmtpConfig {
	server string
	from string
	port int
	username string
	password string
}

pub fn (mut auth Authenticator) email_authentication(config SendMailConfig) ! {
	auth.send_verification_mail(config)!
	auth.await_authentication(email: config.email)!
}

// sends mail with verification link
pub fn (mut auth Authenticator) send_verification_mail(config SendMailConfig) ! {
	// create auth session
	auth_code := rand.bytes(64) or { panic(err) }
	auth.backend.create_auth_session(
		email: config.email
		auth_code: auth_code.hex()
		timeout: time.now().add_seconds(180)
	)!

	link := '<a href="${config.link}/${config.email}/${auth_code.hex()}">Click to authenticate</a>'
	mail := smtp.Mail{
		to: config.email
		from: config.mail.from
		subject: config.mail.subject
		body_type: .html
		body: '${config.mail.body}\n${link}'
	}

	// send email with link in body
	mut client := smtp.new_client(
		server: config.smtp.server
		from: config.smtp.from
		port: config.smtp.port
		username: config.smtp.username
		password: config.smtp.password
	)!
	client.send(mail) or { panic('Error resolving email address') }
	auth.logger.debug('Email Authenticator: Sent authentication email to ${config.email}')
	client.quit() or { panic('Could not close connection to server') }
}

// sends mail with login link
pub fn (mut auth Authenticator) send_login_link(config SendMailConfig) ! {	
	expiration := time.now().add(5 * time.minute)
	data := '${config.email}.${expiration}' // data to be signed
	signature := hmac.new(
		hex.decode(auth.secret),
		data.bytes(),
		sha256.sum,
		sha256.block_size
	).bytestr()

	link := '<a href="${config.link}/${config.email}/${signature}">Click to login</a>'
	auth.logger.debug('Created login link for ${config.email}')

	mail := smtp.Mail{
		to: config.email
		from: config.mail.from
		subject: config.mail.subject
		body_type: .html
		body: '${config.mail.body}\n${link}'
	}

	// send email with link in body
	mut client := smtp.new_client(
		server: config.smtp.server
		from: config.smtp.from
		port: config.smtp.port
		username: config.smtp.username
		password: config.smtp.password
	)!
	client.send(mail) or { panic('Error resolving email address') }
	auth.logger.debug('Email Authenticator: Sent authentication email to ${config.email}')
	client.quit() or { panic('Could not close connection to server') }
}

// result of an authentication attempt
// returns time and attempts remaining
pub struct AttemptResult {
pub:
	authenticated bool
	attempts_left int
	time_left     time.Time
}

enum AuthErrorReason {
	cypher_mismatch
	no_remaining_attempts
	session_not_found
}

struct AuthError {
	Error
	reason AuthErrorReason
}

// authenticates if email/cypher combo correct within timeout and remaining attemts
// TODO: address based request limits recognition to prevent brute
// TODO: max allowed request per seccond to prevent dos
pub fn (mut auth Authenticator) authenticate(email string, cypher string) ! {
	session := auth.backend.read_auth_session(email) or {
		return AuthError {
			reason: .session_not_found
		}
	}
	if session.attempts_left <= 0 { // checks if remaining attempts
		return AuthError {
			reason: .no_remaining_attempts
		}
	}

	// authenticates if cypher in link matches authcode
	if cypher == session.auth_code {
		auth.logger.debug('Email Authenticator: email ${email} authenticated')
		auth.backend.set_session_authenticated(email) or {
			panic(err)
		}
	} else {
		updated_session := AuthSession{
			...session
			attempts_left: session.attempts_left - 1
		}
		auth.backend.update_auth_session(updated_session)!
		return AuthError {
			reason: .cypher_mismatch
		}
	}
}

pub struct AwaitAuthParams {
	email string [required]
	timeout time.Duration = 3 * time.minute
}

// function to check if an email is authenticated
pub fn (mut auth Authenticator) await_authentication(params AwaitAuthParams) ! {
	stopwatch := time.new_stopwatch()
	for stopwatch.elapsed() < params.timeout {
		if auth.is_authenticated(params.email)! { return }
		time.sleep(2 * time.second)
	}
	return error('Authentication timeout.')
}

// function to check if an email is authenticated
pub fn (mut auth Authenticator) is_authenticated(email string) !bool {
	session := auth.backend.read_auth_session(email) or {
		return error('Cant find session')
	}
	return session.authenticated
}
