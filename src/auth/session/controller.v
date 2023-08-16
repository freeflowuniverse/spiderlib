module session

import vweb
import json
import log

// session controller that be be added to vweb projects
pub struct Controller {
	vweb.Context
	authenticator shared Authenticator [required]
}

pub fn new_controller(logger &log.Logger) Controller {
	mut auth := Authenticator{
		logger: unsafe { logger }
	}
	return Controller{
		authenticator: auth
	}
}

// route responsible for verifying email, email form should be posted here
[POST]
pub fn (mut app Controller) new_refresh_token() !vweb.Result {
	params := json.decode(RefreshTokenParams, app.req.data) or { panic('cant decode:${err}') }
	lock app.authenticator {
		token := app.authenticator.new_refresh_token(params)
		return app.json(token)
	}
	return app.ok('')
}

[POST]
pub fn (mut app Controller) new_access_token() !vweb.Result {
	params := json.decode(AccessTokenParams, app.req.data)!
	lock app.authenticator {
		token := app.authenticator.new_access_token(params) or { return app.server_error(500) }
		return app.json(token)
	}
	return app.ok('')
}

[POST]
pub fn (mut app Controller) authenticate_access_token() !vweb.Result {
	token := app.req.data
	lock app.authenticator {
		if auth := app.authenticator.authenticate_access_token(token) {
			return app.json(auth)
		} else {
			return app.json(err.msg())
		}
	}
	return app.ok('')
}
