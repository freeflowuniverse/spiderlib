module tfconnect

import vweb
import json
import rand
import encoding.base64
import libsodium
import toml
import os
import net.http
import freeflowuniverse.spiderlib.auth.tfconnect



const (
	file_dose_not_exist    	= "Couldn't parse kyes file, just make sure that you have kyes.toml by running create_keys.v file, then send its path when you running the client app."
    signed_attempt_missing  = 'signedAttempt parameter is missing.'
	server_host				= "http://localhost:8000"
)


const (
	redirect_url = "https://login.threefold.me"
	sign_len = 64
)

struct LoginUrlArgs{
	app_id string
	server_public_key string
}

pub struct TFConnectResponse {
pub:
	email      string
	identifier string
}

// 
pub fn get_login_url(app_id string, server_public_key string) string {

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
	return "$redirect_url?${tfconnect.url_encode(params)}"
}

pub fn callback(query map[string]string)! string {
	data := SignedAttempt{}

	// if query == {} {
    //     clinet.abort(400, signed_attempt_missing)
	// }

	initial_data := data.load(query)!
	res := request_to_server_to_verify(initial_data)!
	return res.body
}


pub fn request_to_server_to_verify(data SignedAttempt)!http.Response{
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json',
	})

	request := http.Request{
		url: "${server_host}/verify"
		method: http.Method.post
		header: header,
		data: json.encode(data),
	}
	result := request.do()!
	return result
}

pub fn url_encode(map_ map[string]string) string {
	mut formated := ""

	for k, v in map_ {
		if formated != "" {
			formated += "&" + k + "=" + v
		} else {
			formated = k + "=" + v
		}
	}
	return formated
}