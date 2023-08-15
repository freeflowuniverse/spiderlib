module session

import net.http
import json

// session controller that be be added to vweb projects
pub struct Client {
	url string
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

pub fn (c Client) authenticate_access_token(access_token string) !bool {
	url := '${c.url}/authenticate_access_token'
	resp := http.post(url, access_token)!
	is_authenticated := resp.body == 'true'
	return is_authenticated
}
