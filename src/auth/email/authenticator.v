module email

import time
import net.smtp
import crypto.rand
import log

// Creates and updates, authenticates email authentication sessions
[noinit]
struct Authenticator {
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
struct AuthenticatorConfig {
	backend IBackend [required]
	logger &log.Logger = &log.Logger(&log.Log{
		level: .info
	})
}

pub fn new(config AuthenticatorConfig) Authenticator {
	return Authenticator {
		backend: config.backend
		logger: config.logger
	}
}

[params]
pub struct SendMailConfig {
	email string
	mail VerificationMail [required]
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

// sends mail with verification link
pub fn (mut auth Authenticator) send_verification_mail(config SendMailConfig) ! {
	// create auth session
	auth_code := rand.bytes(64) or { panic(err) }
	auth.backend.create_auth_session(
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
	client.quit() or { panic('Could not close connection to server') }
	auth.logger.debug(@FN + ':\nSent verification email to: ${config.email}')
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
		auth.logger.debug(@FN + ':\nUser authenticated email: ${email}')
		updated_session := AuthSession{
			...session
			authenticated: true
		}
		auth.backend.update_auth_session(updated_session)!
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

// function to check if an email is authenticated
pub fn (mut auth Authenticator) is_authenticated(email string) !bool {
	session := auth.backend.read_auth_session(email) or {
		return error('Cant find session')
	}
	return session.authenticated
}
