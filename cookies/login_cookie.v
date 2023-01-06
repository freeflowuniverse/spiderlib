module cookies

import json
import rand

pub struct LoginCookie {
	identifier string
	token string
}

// https://stackoverflow.com/questions/244882/what-is-the-best-way-to-implement-remember-me-for-a-website
pub fn create_login_cookie(identifier string) string {
	cookie := LoginCookie {
		identifier: identifier
		token: 'token'
	}
	return json.encode(cookie)
}