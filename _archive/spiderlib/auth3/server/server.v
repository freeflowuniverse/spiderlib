module server

import vweb
import term
import freeflowuniverse.spiderlib.auth.tfconnect

struct ServerApp {
	vweb.Context
mut: 
	auth_table map[string]
}

fn main() {
	println(term.green("Server app started"))
    vweb.run(&ServerApp{}, 8000)
}
