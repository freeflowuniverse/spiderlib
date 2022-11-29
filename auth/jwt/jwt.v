module jwt

import crypto.hmac
import crypto.sha256
import crypto.bcrypt
import encoding.base64
import json
import rand
import vweb.sse { SSEMessage }
import time
import net.smtp
import crypto.rand as crypto_rand
import os
import freeflowuniverse.spiderlib.publisher2 { Publisher, User, Email, Access }
import vweb

// JWT code in this page is from 
// https://github.com/vlang/v/blob/master/examples/vweb_orm_jwt/src/auth_services.v
// credit to https://github.com/enghitalo

struct JwtHeader {
	alg string
	typ string
}

//TODO: refactor to use single JWT interface
struct JwtPayload {
	sub         string    // (subject)
	iss         string    // (issuer)
	exp         string    // (expiration)
	iat         time.Time // (issued at)
	aud         string    // (audience)
	user		User
}

struct AccessPayload {
	sub         string  
	iss         string
	exp         string  
	iat         time.Time
	aud         string  
	access		Access
	user		string
}

// creates user jwt cookie, enables session keeping
fn make_token(user User) string {
	
	$if debug {
		eprintln(@FN + ':\nCreating cookie token for user: $user')
	}	

	secret := os.getenv('SECRET_KEY')
	jwt_header := JwtHeader{'HS256', 'JWT'}
	jwt_payload := JwtPayload{
		user: user
		iat: time.now()
	}

	header := base64.url_encode(json.encode(jwt_header).bytes())
	payload := base64.url_encode(json.encode(jwt_payload).bytes())
	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.$payload'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	jwt := '${header}.${payload}.$signature'

	return jwt
}

// creates site access token
// used to cache site accesses within session
// TODO: must expire within session in case access revoked
fn make_access_token(access Access, user string) string {
	
	$if debug {
		eprintln(@FN + ':\nCreating access cookie for user: $user')
	}	

	secret := os.getenv('SECRET_KEY')
	jwt_header := JwtHeader{'HS256', 'JWT'}
	jwt_payload := AccessPayload{
		access: access
		user: user
		iat: time.now()
	}

	header := base64.url_encode(json.encode(jwt_header).bytes())
	payload := base64.url_encode(json.encode(jwt_payload).bytes())
	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.$payload'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	jwt := '${header}.${payload}.$signature'

	return jwt
}

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

// gets cookie token, returns user obj
pub fn get_user(token string) ?User {
	if token == '' {
		return error('Cookie token is empty')
	}
	payload := json.decode(JwtPayload, base64.url_decode(token.split('.')[1]).bytestr()) or {
		panic(err)
	}
	return payload.user
}
