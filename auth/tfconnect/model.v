module tfconnect

import vweb
import json
import encoding.base64
import toml

[noinit]
pub struct TFConnect {
pub:
	app_id string
	redirect_url string
	pk_decoded []u8 [required]
	sk_decoded []u8 [required]
}

struct SignedAttempt {
	signed_attempt string
	double_name    string
}

struct ResultData {
	double_name string
	state       string
	nonce       string
	ciphertext  string
}
