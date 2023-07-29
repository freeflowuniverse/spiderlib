module tfconnect

import vweb
import json
import encoding.base64
import toml

[noinit]
pub struct TFConnect {
pub:
	app_id       string // host of the application (ex: http://localhost:8080)
	redirect_url string = 'https://login.threefold.me' // tfconnect auth url to be redirect for auth
	callback     string // path of host which tfconnect will redirect to after authentication attempt (ex: /callback)
	scopes       Scopes // scopes of user info requested from TFConnect
	pk_decoded   []u8   [required] // public key generated for tfconnect
	sk_decoded   []u8   [required] // private key generated for tfconnect
}

// The user information scopes requested from TFConnect
pub struct Scopes {
	user  bool // TFConnect user identifier  (.3bot)
	email bool // TFConnect user email
}

// Data returned upon TFConnect auth callback
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

// Data decoded upon successful authentication
pub struct TFConnectUser {
pub:
	email      string
	identifier string
}
