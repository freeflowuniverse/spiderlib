module tfconnect

import vweb
import json
import x.json2
import encoding.base64
import libsodium
import net.http
import rand

pub fn (tfconnect TFConnect) create_login_url() string {
	server_curve_pk := []u8{len: 32}
	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &tfconnect.pk_decoded[0])
	state := rand.uuid_v4().replace('-', '')
	params := {
		'state':       state
		'appid':       tfconnect.app_id
		'scope':       json.encode({
			'user':  true
			'email': true
		})
		'redirecturl': '/auth/callback'
		'publickey':   base64.encode(server_curve_pk[..])
	}
	return '${redirect_url}?${url_encode(params)}'
}

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

pub fn load_signed_attempt(data map[string]string) !SignedAttempt {
	if data == {} {
		return error('400, signed_attempt_missing')
	}

	data_ := json2.raw_decode(data['signedAttempt'])!
	signed_attempt := data_.as_map()['signedAttempt']!.str()
	double_name := data_.as_map()['doubleName']!.str()
	initial_data := SignedAttempt{signed_attempt, double_name}
	return initial_data
}

	// mut file_path := os.args_after('.')
	// if file_path.len <= 1 {
	// 	server.abort(400, file_dose_not_exist)
	// }
	// file_path << '.'
	// keys := parse_keys(file_path[1])!
	// server_public_key := keys.value('server.SERVER_PUBLIC_KEY').string()
	// server_private_key := keys.value('server.SERVER_SECRET_KEY').string()

	// request_data := json2.raw_decode(server.Context.req.data)!
	// data := SignedAttempt{
	// 	signed_attempt: request_data.as_map()['signed_attempt']!.str()
	// 	double_name: request_data.as_map()['double_name']!.str()
	// }

pub fn (mut app TFConnect) verify(data SignedAttempt) !string {
	
	if data.double_name == '' {
		return TFConnectError {msg: no_double_name}
	}

	res := request_to_get_pub_key(data.double_name)!
	if res.status_code != 200 {
		return error('Error getting user pub key')
	}

	body := json2.raw_decode(res.body)!
	user_pk := body.as_map()['publicKey']!.str()
	user_pk_buff := [32]u8{}
	_ := base64.decode_in_buffer(&user_pk, &user_pk_buff[0])
	signed_data := data.signed_attempt

	// This is just workaround becouse we need to access pub key inside verify key and we can not do it while this struct is private.
	signing_key := libsodium.new_signing_key(user_pk_buff, [32]u8{})
	verify_key := signing_key.verify_key
	verifed := verify_key.verify(base64.decode(signed_data))

	if verifed == false {
		return TFConnectError {msg: data_verfication_field}
	}

	verified_data := base64.decode(signed_data)
	data_obj := json2.raw_decode(verified_data[64..].bytestr())!
	data_ := json2.raw_decode(data_obj.as_map()['data']!.str())!

	res_data_struct := ResultData{data_obj.as_map()['doubleName']!.str(), data_obj.as_map()['signedState']!.str(), data_.as_map()['nonce']!.str(), data_.as_map()['ciphertext']!.str()}

	if res_data_struct.double_name == '' {
		return TFConnectError {msg: not_contain_doublename}
	}

	if res_data_struct.state == '' {
		return TFConnectError {msg: not_contain_state}
	}

	if res_data_struct.double_name != data.double_name {
		return TFConnectError {msg: username_mismatch}
	}

	nonce := base64.decode(res_data_struct.nonce)
	ciphertext := base64.decode(res_data_struct.ciphertext)

	nonce_bff := [24]u8{}
	unsafe { vmemcpy(&nonce_bff[0], nonce.data, 24) }

	user_curve_pk := []u8{len: 32}
	server_curve_sk := []u8{len: 32}
	server_curve_pk := []u8{len: 32}

	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(user_curve_pk.data, &user_pk_buff[0])
	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &app.pk_decoded[0])
	_ := libsodium.crypto_sign_ed25519_sk_to_curve25519(server_curve_sk.data, &app.sk_decoded[0])

	mut new_private_key := libsodium.PrivateKey{
		public_key: server_curve_pk
		secret_key: server_curve_sk
	}

	mut box := libsodium.Box{
		nonce: nonce_bff
		public_key: user_curve_pk
		key: new_private_key
	}

	decrypted_bytes := box.decrypt(ciphertext)
	response_email := json2.raw_decode(decrypted_bytes.bytestr())!
	response := json2.raw_decode(response_email.as_map()['email']!.str())!

	if response.as_map()['email']!.str() == '' {
		return TFConnectError {msg: data_decrypting_error}
	}

	sei := response.as_map()['sei']!
	verify_sei := request_to_verify_sei(sei.str())!

	if verify_sei.status_code != 200 {
		return TFConnectError {msg: email_not_verified}
	}

	return '${verify_sei.body}'
}

fn request_to_get_pub_key(username string) !http.Response {
	mut header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})
	config := http.FetchConfig{
		header: header
		method: http.Method.get
	}
	url := 'https://login.threefold.me/api/users/${username}'
	resp := http.fetch(http.FetchConfig{ ...config, url: url })!
	println(resp)
	return resp
}

fn request_to_verify_sei(sei string) !http.Response {
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})

	request := http.Request{
		url: 'https://openkyc.live/verification/verify-sei'
		method: http.Method.post
		header: header
		data: json.encode({
			'signedEmailIdentifier': sei
		})
	}
	result := request.do()!
	return result
}