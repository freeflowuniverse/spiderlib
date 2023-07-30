module email

import vweb
import time
import net.http

// email authentication controller that be be added to vweb projects
pub struct Controller {
	vweb.Context
	authenticator shared Authenticator [required]
}

// route responsible for verifying email, email form should be posted here
[POST]
pub fn (mut app Controller) verify_email() vweb.Result {
	data := http.parse_form(app.req.data)
	address := data['email']
	lock app.authenticator {
		_ := app.authenticator.email_verification(data['email'])
	}
	// checks if email verified every 2 seconds
	for {
		lock app.authenticator {
			if app.authenticator.is_authenticated(address) {
				// returns success message once verified
				return app.html('Email ${address} has been verified')
			}
		}
		time.sleep(2 * time.second)
	}
	return app.html('timeout')
}

['/authenticate/:address/:cypher']
pub fn (mut app Controller) authenticate(address string, cypher string) vweb.Result {
	lock app.authenticator {
		app.authenticator.authenticate(address, cypher)
	}
	return app.html('Email verified')
}
