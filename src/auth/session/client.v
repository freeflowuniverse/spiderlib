module session

import net.http
import json
import freeflowuniverse.spiderlib.auth.jwt

// session controller that be be added to vweb projects
pub struct Client {
	url string [required]
}

pub fn (c Client) new_auth_tokens(params RefreshTokenParams) !AuthTokens {
	println('posting: ${c.url}/new_auth_tokens')
	resp := http.post('${c.url}/new_auth_tokens', json.encode(params)) or { panic(err) }
	tokens := json.decode(AuthTokens, resp.body) or { panic('This should never happen ${err}') }
	return tokens
}

pub fn (c Client) new_refresh_token(params RefreshTokenParams) !string {
	resp := http.post('${c.url}/new_refresh_token', json.encode(params))!
	// todo response error check
	token := resp.body.trim('"')
	return token
}

pub fn (c Client) new_access_token(params AccessTokenParams) !string {
	resp := http.post('${c.url}/new_access_token', json.encode(params))!
	// todo response error check
	token := resp.body.trim('"')
	return token
}

pub fn (c Client) authenticate_access_token(access_token string) ! {
	url := '${c.url}/authenticate_access_token'
	resp := http.post(url, access_token) or{ panic('this should never happen ${err}')}
	if resp.status_code != 200 {
		return error(resp.body)
	}
}

pub fn (c Client) get_token_subject(access_token string) !string {
	c.authenticate_access_token(access_token) or { return error(err.msg()) }
	return jwt.SignedJWT(access_token).decode_subject() or { panic(err) }
}
