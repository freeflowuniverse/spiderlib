module tfconnect

import libsodium
import net.http
import x.json2
import json
import encoding.base64

struct ResultData {
	double_name string
	state       string
	nonce       string
	ciphertext  string
}

pub fn verify(server_public_key string, server_private_key string, req_data string) ! {
	server_pk_decoded_32 := [32]u8{}
	server_sk_decoded_64 := [64]u8{}

	_ := base64.decode_in_buffer(&server_public_key, &server_pk_decoded_32)
	_ := base64.decode_in_buffer(&server_private_key, &server_sk_decoded_64)

	request_data := json2.raw_decode(req_data)!
	data := SignedAttempt{
		signed_attempt: request_data.as_map()['signed_attempt']!.str()
		double_name: request_data.as_map()['double_name']!.str()
	}

	// if data.double_name == ""{
	// 	server.abort(400, no_double_name)
	// }

	res := request_to_get_pub_key(data.double_name)!
	// if res.status_code != 200{
	// 	server.abort(400, "Error getting user pub key")
	// }

	body := json2.raw_decode(res.body)!
	user_pk := body.as_map()['publicKey']!.str()
	user_pk_buff := [32]u8{}
	_ := base64.decode_in_buffer(&user_pk, &user_pk_buff)
	signed_data := data.signed_attempt

	// This is just workaround becouse we need to access pub key inside verify key and we can not do it while this struct is private.
	signing_key := libsodium.new_signing_key(user_pk_buff, [32]u8{})
	verify_key := signing_key.verify_key
	verifed := verify_key.verify(base64.decode(signed_data))

	// if verifed == false{
	// 	server.abort(400, data_verfication_field)
	// }

	verified_data := base64.decode(signed_data)
	data_obj := json2.raw_decode(verified_data[64..].bytestr())!
	data_ := json2.raw_decode(data_obj.as_map()['data']!.str())!

	res_data_struct := ResultData{data_obj.as_map()['doubleName']!.str(), data_obj.as_map()['signedState']!.str(), data_.as_map()['nonce']!.str(), data_.as_map()['ciphertext']!.str()}

	// if res_data_struct.double_name == ""{
	// 	server.abort(400, not_contain_doublename)
	// }

	// if res_data_struct.state == ""{
	// 	server.abort(400, not_contain_state)
	// }

	// if res_data_struct.double_name != data.double_name{
	// 	server.abort(400, username_mismatch)
	// }

	nonce := base64.decode(res_data_struct.nonce)
	ciphertext := base64.decode(res_data_struct.ciphertext)

	nonce_bff := [24]u8{}
	unsafe { vmemcpy(&nonce_bff[0], nonce.data, 24) }

	user_curve_pk := []u8{len: 32}
	server_curve_sk := []u8{len: 32}
	server_curve_pk := []u8{len: 32}

	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(user_curve_pk.data, &user_pk_buff)
	_ := libsodium.crypto_sign_ed25519_pk_to_curve25519(server_curve_pk.data, &server_pk_decoded_32[0])
	_ := libsodium.crypto_sign_ed25519_sk_to_curve25519(server_curve_sk.data, &server_sk_decoded_64[0])

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

	// if response.as_map()['email']!.str() == "" {
	// 	server.abort(400, data_decrypting_error)
	// }

	sei := response.as_map()['sei']!
	verify_sei := request_to_verify_sei(sei.str())!

	// if verify_sei.status_code != 200{
	//     server.abort(400, email_not_verified)
	// }
}

pub fn request_to_get_pub_key(username string) !http.Response {
	mut header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})
	config := http.FetchConfig{
		header: header
		method: http.Method.get
	}
	url := 'https://login.threefold.me/api/users/${username}'
	resp := http.fetch(http.FetchConfig{ ...config, url: url })!
	return resp
}

pub fn request_to_verify_sei(sei string) !http.Response {
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
