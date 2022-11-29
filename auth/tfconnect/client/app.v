module main
import vweb
import term
import os
import encoding.base64
import json
import toml
import rand
import freeflowuniverse.crystallib.auth {CustomResponse}
import libsodium

// To run client app
struct ClientApp {
	vweb.Context
}

pub fn (mut client ClientApp)abort(status int, message string){
	client.set_status(status, message)
	er := CustomResponse{status, message}
	client.json(er.to_json())
}

fn main() {
	println(term.green('Client app started'))
	vweb.run(&ClientApp{}, 8080)
}


