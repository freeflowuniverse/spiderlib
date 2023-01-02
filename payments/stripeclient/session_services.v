module stripeclient

import json

pub fn (client StripeClient) create_session(args SessionArgs) !Session {
	mut data := urlencode(args)!
	// data = format(data, '')!
	response := client.post_request('checkout/sessions', data)!
	return json.decode(Session, response)
}
