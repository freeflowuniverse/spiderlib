module tfconnect

import vweb
import json
import x.json2
import encoding.base64
import libsodium
import net.http
import rand

struct Client {
pub:
	url string
}

// todo: inquire and document timeout
// create_login_url creates a one time redirect url for threefold connect authentication
pub fn (client Client) create_login_url(params LoginUrlConfig) !string {
	resp := http.post('${client.url}/create_login_url', json.encode(params))!
	token := resp.body.trim('"')
	return token
}
