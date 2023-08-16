module email

import vweb
import time
import json
import log

const agent = 'Email Authentication Controller'

// email authentication controller that be be added to vweb projects
[heap]
pub struct Controller {
	vweb.Context
	authenticator shared Authenticator [required]
	callback      string               [vweb_global]
mut:
	logger &log.Logger [vweb_global] = &log.Logger(&log.Log{
	level: .debug
})
}

[params]
pub struct ControllerParams {
	logger        &log.Logger
	authenticator Authenticator
}

pub fn new_controller(params ControllerParams) Controller {
	mut app := Controller{
		logger: params.logger
		authenticator: params.authenticator
	}
	return app
}

// route responsible for verifying email, email form should be posted here
[POST]
pub fn (mut app Controller) send_verification_email() vweb.Result {
	address := app.req.data
	app.logger.debug('${email.agent}: received request to verify email')
	lock app.authenticator {
		session := app.authenticator.email_verification(address)
		app.logger.debug('${email.agent}: Sent verification email')
		return app.json(session)
	}
	app.logger.debug('${email.agent}: sent verification email')
	return app.html('timeout')
}

// route responsible for verifying email, email form should be posted here
[POST]
pub fn (mut app Controller) is_verified() vweb.Result {
	address := app.req.data
	// checks if email verified every 2 seconds
	for {
		lock app.authenticator {
			if app.authenticator.is_authenticated(address) {
				// returns success message once verified
				app.logger.debug('${email.agent}: verified email')
				return app.json(app.authenticator.sessions[address])
			}
		}
		time.sleep(2 * time.second)
	}
	return app.html('timeout')
}

// route responsible for verifying email, email form should be posted here
[POST]
pub fn (mut app Controller) verify() vweb.Result {
	address := app.req.data
	app.logger.debug('${email.agent}: received request to verify email')
	lock app.authenticator {
		_ := app.authenticator.email_verification(address)
	}
	app.logger.debug('${email.agent}: sent verification email')
	// checks if email verified every 2 seconds
	for {
		lock app.authenticator {
			if app.authenticator.is_authenticated(address) {
				// returns success message once verified
				app.logger.debug('${email.agent}: verified email')
				return app.json(app.authenticator.sessions[address])
			}
		}
		time.sleep(2 * time.second)
	}
	return app.html('timeout')
}

pub struct AuthAttempt {
pub:
	ip      string
	address string
	cypher  string
}

[POST]
pub fn (mut app Controller) authenticate() !vweb.Result {
	attempt := json.decode(AuthAttempt, app.req.data)!
	mut result := AttemptResult{}
	lock app.authenticator {
		result = app.authenticator.authenticate(attempt.address, attempt.cypher)!
	}
	return app.json(result)
}
