module main

import json
import net.http
import freeflowuniverse.spiderlib.auth.email

// verify_email posts an email verification req to the email auth controller
pub fn verify_email(address string) !email.AuthSession {
	url := 'http://localhost:8080/email_controller/verify'
	resp := http.post(url, address)!
	session := json.decode(email.AuthSession, resp.body)!
	return session
}

// authenticate posts an authentication attempt req to the email auth controller
pub fn authenticate_email(address string, cypher string) !email.AttemptResult {
	url := 'http://localhost:8080/email_controller/authenticate'
	resp := http.post(url, json.encode(email.AuthAttempt{
		address: address
		cypher: cypher
	}))!
	result := json.decode(email.AttemptResult, resp.body)!
	return result
}
