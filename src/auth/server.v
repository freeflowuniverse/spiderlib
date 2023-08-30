module auth

import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session
import freeflowuniverse.spiderlib.auth.tfconnect
import vweb
import log

[noinit]
struct Server {
	vweb.Context
	vweb.Controller
mut:
	logger &log.Logger [vweb_global] = &log.Logger(&log.Log{
	level: .debug
})
}

[params]
pub struct ServerConfig {
mut:
	logger &log.Logger [vweb_global] = &log.Logger(&log.Log{
		level: .debug
	})
}

pub fn new_server(config ServerConfig) ! Server {
	mut email_ctrl := email.new_controller(
		logger: config.logger
		authenticator: email.new(
			logger: config.logger
			backend: email.new_database_backend()!
		)
	)
	mut session_ctrl := session.new_controller(
		logger: config.logger
		authenticator: session.new(
			logger: config.logger
			backend: session.new_database_backend()!
		)
	)
	mut tfconnect_ctrl := tfconnect.new_controller(
		tfconnect: tfconnect.new()!
	)!

	return Server{
		controllers: [
			vweb.controller('/email_authenticator', &email_ctrl),
			vweb.controller('/session_authenticator', &session_ctrl),
		]
	}
}

pub fn (mut server Server) before_request() {
	server.logger.debug(server.req.url)
}