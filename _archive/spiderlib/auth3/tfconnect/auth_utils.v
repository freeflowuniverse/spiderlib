module tfconnect

import toml
import json
import x.json2

pub struct CustomResponse {
	status  int
	message string
}

pub struct SignedAttempt {
	signed_attempt string
	double_name    string
}

pub fn parse_keys(file_path string) !toml.Doc {
	return toml.parse_file(file_path)!
}

pub fn (c CustomResponse) to_json() string {
	return json.encode(c)
}

pub fn (s SignedAttempt) load(data map[string]string) !SignedAttempt {
	data_ := json2.raw_decode(data['signedAttempt'])!
	signed_attempt := data_.as_map()['signedAttempt']!.str()
	double_name := data_.as_map()['doubleName']!.str()
	initial_data := SignedAttempt{signed_attempt, double_name}
	return initial_data
}
