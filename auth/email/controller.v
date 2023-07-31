module email

import vweb
import time
import net.http
import json

// email authentication controller that be be added to vweb projects
pub struct Controller {
	vweb.Context
	authenticator shared Authenticator [required]
	callback      string               [vweb_global]
	// callback_fn fn(string)
}

// route responsible for verifying email, email form should be posted here
[POST]
pub fn (mut app Controller) verify() vweb.Result {
	address := app.req.data
	lock app.authenticator {
		_ := app.authenticator.email_verification(address)
	}
	// checks if email verified every 2 seconds
	for {
		lock app.authenticator {
			if app.authenticator.is_authenticated(address) {
				// returns success message once verified
				return app.json(app.authenticator.sessions[address])
			}
		}
		time.sleep(2 * time.second)
	}
	println('broken')
	println('s: ${app.callback}')
	app.redirect(app.callback)
	println('redirected')
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
