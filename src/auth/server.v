module auth

import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session
import freeflowuniverse.spiderlib.auth.tfconnect
import vweb

[noinit]
struct Server {
	vweb.Context
	vweb.Controller
}

struct ServerConfig {
}

pub fn new() {
	mut email_ctrl := create_email_controller()
	mut session_ctrl := session.new_controller()
	mut tfconnect_ctrl := tfconnect.new_controller(
		tfconnect: tfconnect.new(
			app_id: host
		)!
	)!

	return AuthServer{
		controllers: [
			vweb.controller('/email', &email_ctrl),
			vweb.controller('/session', &session_ctrl),
		]
	}
}
