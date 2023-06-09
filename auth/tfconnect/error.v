module tfconnect

import json

// error message constants
const (
	file_dose_not_exist    = "Couldn't parse kyes file, just make sure that you have kyes.toml by running create_keys.v file, then send its path when you running the client app."
	signed_attempt_missing = 'signedAttempt parameter is missing.'
	invalid_json           = 'Invalid JSON Payload.'
	no_double_name         = 'DoubleName is missing.'
	data_verfication_field = 'Data verfication failed!.'
	not_contain_doublename = 'Decrypted data does not contain (doubleName).'
	not_contain_state      = 'Decrypted data does not contain (state).'
	username_mismatch      = 'username mismatch!'
	data_decrypting_error  = 'Error decrypting data!'
	email_not_verified     = 'Email is not verified'
)

struct TFConnectError {
	Error
	msg string
}

fn (err TFConnectError) code() int {
	if err.msg == no_double_name {
		return 400
	}
	return 404
}

struct CustomResponse {
	status  int
	message string
}

fn (c CustomResponse) to_json() string {
	return json.encode(c)
}
