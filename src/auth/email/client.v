module email

import net.http
import time
import json

// session controller that be be added to vweb projects
pub struct Client {
	url string [required]
}

// verify_email posts an email verification req to the email auth controller
pub fn (c Client) verify_email(address string) !AuthSession {
	resp := http.post('${c.url}/verify', address)!
	session := json.decode(AuthSession, resp.body)!
	return session
}

// verify_email posts an email verification req to the email auth controller
pub fn (c Client) is_verified(address string) !AuthSession {
	mut req := http.new_request(http.Method.post, '${c.url}/is_verified', address)
	req.read_timeout = 180 * time.second
	req.write_timeout = 180 * time.second
	resp := req.do()!
	// resp := http.post('${c.url}/is_verified', address) or {panic('here:${err}')}
	session := json.decode(AuthSession, resp.body)!
	return session
}

// send_verification_email posts an email verification req to the email auth controller
pub fn (c Client) send_verification_email(address string) !AuthSession {
	resp := http.post('${c.url}/send_verification_email', address)!
	session := json.decode(AuthSession, resp.body)!
	return session
}

// authenticate posts an authentication attempt req to the email auth controller
pub fn (c Client) authenticate(address string, cypher string) !AttemptResult {
	resp := http.post('${c.url}/authenticate', json.encode(AuthAttempt{
		address: address
		cypher: cypher
	}))!
	result := json.decode(AttemptResult, resp.body)!
	return result
}
