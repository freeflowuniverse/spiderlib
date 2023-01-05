module publisher

import json
import freeflowuniverse.spiderlib.auth.jwt
import freeflowuniverse.spiderlib.auth.tfconnect { TFConnectResponse, SignedAttempt }
import freeflowuniverse.spiderlib.user { Email }

// tfconnect login receives a tfconnect response token, verifies it,
// logs in / registers user, requests and returns an access token
pub fn (mut p Publisher) login_tfconnect(query map[string]string) !string {

	data := SignedAttempt{}
	initial_data := data.load(query)!

	// verify token from auth server and decode
	response := tfconnect.request_to_server_to_verify(initial_data)!
	tfconnect_response := json.decode(TFConnectResponse, response.body)!
	username := tfconnect_response.identifier
	email := Email{
		address: tfconnect_response.email
		authenticated: true // assume tfconnect email to be authenticated
	}

	// todo: check if email exists under another user
	// register if user doesn't exist
	user := p.get_user(username) or { p.register(username, email) }

	// ? maybe combine this with response received from server 
	// returns jwt storing user identifier
	mut payload := jwt.JwtPayload{}
	return jwt.create_token(mut payload)
}

// email login receives an email verification response token, verifies it,
// logs in / registers user, requests and returns an access token
pub fn (mut p Publisher) login_email(query map[string]string) !string {

	data := SignedAttempt{}
	initial_data := data.load(query)!

	// verify token from auth server and decode
	response := tfconnect.request_to_server_to_verify(initial_data)!
	tfconnect_response := json.decode(TFConnectResponse, response.body)!
	username := tfconnect_response.identifier
	email := Email {
		address: tfconnect_response.email
		authenticated: true // assume tfconnect email to be authenticated
	}

	// todo: check if email exists under another user
	// register if user doesn't exist
	user := p.get_user(username) or { p.register(username, email) }

	// ? maybe combine this with response received from server 
	// returns jwt with user identifier
	mut payload := jwt.JwtPayload {iss: 'api.publisher.tf', sub: user.uuid, data: json.encode(user)}
	return jwt.create_token(mut payload)
}

// register creates new user and adds it to publishers users map
fn (mut p Publisher) register(name string, email Email) User {
	p.users[name] = User{
		name: name
		emails: [email]
	}
	return p.users[name]
}

// get_user returns user with a given username if it exists
fn (p Publisher) get_user(username string) ?User {
	return p.users[username]
}
