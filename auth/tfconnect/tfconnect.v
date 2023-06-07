module tfconnect

import vweb
import json
import encoding.base64
import toml

const (
	file_dose_not_exist    = "Couldn't parse kyes file, just make sure that you have kyes.toml by running create_keys.v file, then send its path when you running the client app."
	signed_attempt_missing = 'signedAttempt parameter is missing.'
	invalid_json           = 'Invalid JSON Payload.'
	no_double_name         = 'DoubleName is missing.'
	data_verfication_field = 'Data verfication failed!.'
	not_contain_doublename = 'Decrypted data does not contain (doubleName).'
	not_contain_state      = 'Decrypted data does not contain (state).'
	username_mismatch      = 'username mismatch!'
	data_decrypting_error  = 'Error decrypting data!'
	email_not_verified     = 'Email is not verified'
)

[noinit]
pub struct TFConnect {
	vweb.Context
pub:
	redirect_url string
	pk_decoded []u8
	sk_decoded []u8
}

[params]
pub struct TFConnectConfig {
pub:
	redirect_url string = 'https://login.threefold.me'
	public_key string [required]
	private_key string [required]
}

	// mut server_public_key := ''
	// mut file_path := os.args_after('.')
	// if file_path.len <= 1 {
	// 	app.abort(400, file_dose_not_exist)
	// }
	// file_path << '.'
	// keys := parse_keys(file_path[1])!
	// if keys.value('server') == toml.Any(toml.Null{}) {
	// 	app.abort(400, file_dose_not_exist)
	// } else {
	// 	server_public_key = keys.value('server.SERVER_PUBLIC_KEY').string()
	// }

pub fn new(config TFConnectConfig) !TFConnect {
	// todo: more checking if pk is valid
	if config.public_key == '' || config.private_key == '' {
		return error('Public and private key must be provided.')
	}

	pk_decoded_32 := [32]u8{}
	sk_decoded_64 := [64]u8{}

	_ := base64.decode_in_buffer(&server_public_key, &pk_decoded_32)
	_ := base64.decode_in_buffer(&server_private_key, &sk_decoded_64)

	// _ := base64.decode_in_buffer(&config.server_public_key, &server_pk_decoded_32)
	// _ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &server_pk_decoded_32[0])

	return TFConnect{
		redirect_url: config.redirect_url
		pk_decoded: pk_decoded_32
		sk_decoded: sk_decoded_64
	}
}

fn parse_keys(file_path string) !toml.Doc {
	return toml.parse_file(file_path)!
}

struct CustomResponse {
	status  int
	message string
}

struct SignedAttempt {
	signed_attempt string
	double_name    string
}

fn (c CustomResponse) to_json() string {
	return json.encode(c)
}
