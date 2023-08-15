module jwt

import crypto.hmac
import crypto.sha256
import crypto.bcrypt
import encoding.base64
import json
import vweb.sse
import time
import crypto.rand as crypto_rand
import os
import vweb

// JWT code in this page is from
// https://github.com/vlang/v/blob/master/examples/vweb_orm_jwt/src/auth_services.v
// credit to https://github.com/enghitalo

struct JwtHeader {
	alg string
	typ string
}

// TODO: refactor to use single JWT interface
// todo: we can name these better
pub struct JwtPayload {
pub mut:
	sub  string    // (subject)
	iss  string    // (issuer)
	exp  string    // (expiration)
	iat  time.Time // (issued at)
	aud  string    // (audience)
	data string
}

// creates jwt with encoded payload and header
// DOESN'T handle data encryption, sensitive data should be encrypted
pub fn create_token(mut jwt_payload JwtPayload) string {
	$if debug {
		eprintln(@FN + ':\nCreating JSON web token for payload: ${payload}')
	}

	secret := os.getenv('SECRET_KEY')
	jwt_header := JwtHeader{'HS256', 'JWT'}
	jwt_payload.iat = time.now()

	header := base64.url_encode(json.encode(jwt_header).bytes())
	payload := base64.url_encode(json.encode(jwt_payload).bytes())
	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.${payload}'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	return '${header}.${payload}.${signature}'
}

// // creates site access token
// // used to cache site accesses within session
// // TODO: must expire within session in case access revoked
// pub fn make_access_token(access Access, user string) string {

// 	$if debug {
// 		eprintln(@FN + ':\nCreating access cookie for user: $user')
// 	}	

// 	secret := os.getenv('SECRET_KEY')
// 	jwt_header := JwtHeader{'HS256', 'JWT'}
// 	jwt_payload := AccessPayload{
// 		access: access
// 		user: user
// 		iat: time.now()
// 	}

// 	header := base64.url_encode(json.encode(jwt_header).bytes())
// 	payload := base64.url_encode(json.encode(jwt_payload).bytes())
// 	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.$payload'.bytes(),
// 		sha256.sum, sha256.block_size).bytestr().bytes())

// 	jwt := '${header}.${payload}.$signature'

// 	return jwt
// }

// verifies jwt cookie
pub fn verify_jwt(token string) bool {
	if token == '' {
		return false
	}
	secret := os.getenv('SECRET_KEY')
	token_split := token.split('.')

	signature_mirror := hmac.new(secret.bytes(), '${token_split[0]}.${token_split[1]}'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes()

	signature_from_token := base64.url_decode(token_split[2])

	return hmac.equal(signature_from_token, signature_mirror)
}

// verifies jwt cookie
// todo: implement assymetric verification
pub fn verify_jwt_assymetric(token string, pk string) bool {
	return false
}

// gets cookie token, returns user obj
pub fn get_data(token string) !string {
	if token == '' {
		return error('Failed to decode token: token is empty')
	}
	payload := json.decode(JwtPayload, base64.url_decode(token.split('.')[1]).bytestr()) or {
		panic(err)
	}
	return payload.data
}

// gets cookie token, returns user obj
pub fn get_payload(token string) !JwtPayload {
	if token == '' {
		return error('Failed to decode token: token is empty')
	}
	encoded_payload := base64.url_decode(token.split('.')[1]).bytestr()
	return json.decode(JwtPayload, encoded_payload)!
}

// // gets cookie token, returns access obj
// pub fn get_access(token string, username string) ?Access {
// 	if token == '' {
// 		return error('Cookie token is empty')
// 	}
// 	payload := json.decode(AccessPayload, base64.url_decode(token.split('.')[1]).bytestr()) or {
// 		panic(err)
// 	}
// 	if payload.user != username {
// 		return error('Access cookie is for different user')
// 	}
// 	return payload.access
// }
