module main

import vweb
import term
import freeflowuniverse.crystallib.auth

struct ServerApp {
	vweb.Context
}

fn main() {
	println(term.green('Server app started'))
	vweb.run(&ServerApp{}, 8000)
}

pub fn (mut server ServerApp) abort(status int, message string) {
	server.set_status(status, message)
	er := auth.CustomResponse{status, message}
	server.json(er.to_json())
}
