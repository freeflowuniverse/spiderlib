module api
import vweb
import x.json2
import encoding.base64
import libsodium
import os
import freeflowuniverse.spiderlib.auth.tfconnect


["/tfconnect_verify"; post]
fn (mut server App) tfconnect_verify()! vweb.Result {
	mut file_path := os.args_after(".")
	// if file_path.len <= 1{
	// 	server.abort(400, file_dose_not_exist)
	// }
	file_path << "."
	// keys := parse_keys(file_path[1])!
	server_public_key 	:= '8gWG5JzSmBJU+4iGRJc4MCLSs1H3uLstVfwQoSJQWWg='
	server_private_key 	:= 'D4MyV9b6Yu4/4+6fFiAke1DJBL0CHKdHC3yNJpXAfEo='
	println(';here')

	// tfconnect.verify(server_public_key, server_private_key)

	
	return server.text("body")
	// return server.text("$verify_sei.body")
}