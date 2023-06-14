module tfconnect

import encoding.base64
import toml

[params]
pub struct TFConnectConfig {
pub:
	app_id string [required]
	redirect_url string = 'https://login.threefold.me'
	callback string
	keypair ?Keypair
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

	keypair := config.keypair or { create_keypair() }

	pk_decoded_32 := []u8{len: 32}
	sk_decoded_64 := []u8{len: 64}
	// pk_decoded_32 := [32]u8{}
	// sk_decoded_64 := [64]u8{}

	_ := base64.decode_in_buffer(&keypair.public_key, pk_decoded_32.data)
	_ := base64.decode_in_buffer(&keypair.private_key, sk_decoded_64.data)

	// _ := base64.decode_in_buffer(&config.server_public_key, &server_pk_decoded_32)
	// _ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &server_pk_decoded_32[0])

	return TFConnect{
		app_id: config.app_id
		redirect_url: config.redirect_url
		callback: config.callback
		pk_decoded: pk_decoded_32
		sk_decoded: sk_decoded_64
	}
}

fn parse_keys(file_path string) !toml.Doc {
	return toml.parse_file(file_path)!
}