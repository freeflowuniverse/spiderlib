module main

import freeflowuniverse.spiderlib.auth
import log
import vweb

fn run_auth_server() {
	mut logger := log.Logger(&log.Log{
		level: .debug
	})
	auth_server := auth.new_server(
		// logger: &logger
	) or { panic(err) }
	vweb.run_at(&auth_server, port: 8000, nr_workers:2) or {
		panic(err)
	}
}

fn main() {
	run_auth_server()
}
