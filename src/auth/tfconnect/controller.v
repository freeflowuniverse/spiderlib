module tfconnect

import vweb

const (
	redirect_url = 'https://login.threefold.me'
	server_host  = 'http://localhost:8000'
	sign_len     = 64
)

// TFConnect controller ready to be imported and added to any vweb application
pub struct TFConnectController {
	vweb.Context
pub:
	success_url string [required; vweb_global]
	failure_url string [required; vweb_global]
pub mut:
	tfconnect TFConnect [required; vweb_global]
}

pub struct ControllerConfig {
	tfconnect   TFConnect
	success_url string
	failure_url string
}

pub fn new_controller(config ControllerConfig) !TFConnectController {
	return TFConnectController{
		tfconnect: config.tfconnect
		success_url: config.success_url
		failure_url: config.failure_url
	}
}

// login route, redirects to tfconnect login
['/login']
pub fn (mut app TFConnectController) login() !vweb.Result {
	login_url := app.tfconnect.create_login_url()
	return app.redirect(login_url)
}

// callback route, verifies and decodes callback from TFConnect
['/callback']
pub fn (mut app TFConnectController) callback() !vweb.Result {
	query := app.query.clone()
	signed_attempt := load_signed_attempt(query)!
	_ := app.tfconnect.verify(signed_attempt)!
	app.redirect(app.success_url)
	return app.ok('')
}

// abort aborts authentication in case of error, and returns error
fn (mut app TFConnectController) abort(status int, message string) {
	app.set_status(status, message)
	er := CustomResponse{status, message}
	app.json(er.to_json())
}
