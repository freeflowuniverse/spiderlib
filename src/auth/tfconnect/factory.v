module tfconnect

import encoding.base64
import toml

[params]
pub struct TFConnectConfig {
pub:
	callback string   // by default, calls back to host url
	keypair  ?Keypair // keypair for creating TFConnect url and decrypting callback data
	scopes   Scopes
}

// new creates and configures TFConnect struct with formatted keys
pub fn new(config TFConnectConfig) !TFConnect {
	keypair := config.keypair or { create_keypair() }

	pk_decoded_32 := []u8{len: 32}
	sk_decoded_64 := []u8{len: 64}

	_ := base64.decode_in_buffer(&keypair.public_key, pk_decoded_32.data)
	_ := base64.decode_in_buffer(&keypair.private_key, sk_decoded_64.data)

	return TFConnect{
		callback: config.callback
		pk_decoded: pk_decoded_32
		sk_decoded: sk_decoded_64
		scopes: config.scopes
	}
}

fn parse_keys(file_path string) !toml.Doc {
	return toml.parse_file(file_path)!
}
