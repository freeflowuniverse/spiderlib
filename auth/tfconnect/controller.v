module tfconnect

import vweb
import json
import x.json2
import rand
import encoding.base64
import libsodium

const (
	redirect_url = 'https://login.threefold.me'
	sign_len     = 64
)

['/login']
pub fn (mut app TFConnect) login() !vweb.Result {
	server_curve_pk := []u8{len: 32}
	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &app.pk_decoded[0])

	app_id := app.get_header('Host')

	state := rand.uuid_v4().replace('-', '')
	params := {
		'state':       state
		'appid':       app_id
		'scope':       json.encode({
			'user':  true
			'email': true
		})
		'redirecturl': '/auth/callback'
		'publickey':   base64.encode(server_curve_pk[..])
	}
	return app.redirect('${redirect_url}?${url_encode(params)}')
}

['/callback']
pub fn (mut app TFConnect) callback() !vweb.Result {
	query := app.query.clone()

	if query == {} {
		app.abort(400, signed_attempt_missing)
	}

	signed_attempt := load_signed_attempt(query)!
	res := app.service_verify(signed_attempt)!
	return app.text('${res}')
}

fn load_signed_attempt(data map[string]string) !SignedAttempt {
	data_ := json2.raw_decode(data['signedAttempt'])!
	signed_attempt := data_.as_map()['signedAttempt']!.str()
	double_name := data_.as_map()['doubleName']!.str()
	initial_data := SignedAttempt{signed_attempt, double_name}
	return initial_data
}

const (
	server_host            = 'http://localhost:8000'
)

fn url_encode(map_ map[string]string) string {
	mut formated := ''

	for k, v in map_ {
		if formated != '' {
			formated += '&' + k + '=' + v
		} else {
			formated = k + '=' + v
		}
	}
	return formated
}

fn (mut app TFConnect) abort(status int, message string) {
	app.set_status(status, message)
	er := CustomResponse{status, message}
	app.json(er.to_json())
}