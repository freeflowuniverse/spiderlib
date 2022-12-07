module main

import vweb
import json
import rand
import encoding.base64
import libsodium
import toml
import os
import freeflowuniverse.crystallib.auth


const (
	redirect_url = "https://login.threefold.me"
	sign_len = 64
)

["/login"]
pub fn (mut clinet ClientApp) login() vweb.Result {
	app_id := clinet.get_header('Host')
	mut server_public_key := ""
	mut file_path := os.args_after(".")
	if file_path.len <= 1{
		clinet.abort(400, 'file_dose_not_exist')
	}
	file_path << "."
	println(file_path)
	keys := auth.parse_keys(file_path[1]) or {panic(err)}
	// keys := auth.parse_keys('../keys.toml') or {panic(err)}
	if keys.value("server") == toml.null{
		clinet.abort(400, 'file_dose_not_exist')
	} else {
		server_public_key = keys.value('server.SERVER_PUBLIC_KEY').string()
	}
	server_pk_decoded_32 := [32]u8{}
	server_curve_pk := []u8{len: 32}

	_ := base64.decode_in_buffer(&server_public_key, &server_pk_decoded_32)
	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &server_pk_decoded_32[0])

	state := rand.uuid_v4().replace("-", "")
	params := {
        "state": state,
        "appid": app_id,
        "scope": json.encode({"user": true, "email": true}),
        "redirecturl": "/callback",
        "publickey": base64.encode(server_curve_pk[..]),
    }
	return clinet.redirect("$redirect_url?${auth.url_encode(params)}")
}

["/callback"]
fn (mut clinet ClientApp) callback()! vweb.Result {
	data := SignedAttempt{}
	query := clinet.query.clone()

	if query == {} {
        clinet.abort(400, signed_attempt_missing)
	}

	initial_data := data.load(query)!
	res := request_to_server_to_verify(initial_data)!
	return clinet.text("${res.body}")
}