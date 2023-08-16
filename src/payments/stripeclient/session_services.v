module stripeclient

import json

pub fn (client StripeClient) create_session(args SessionArgs) !Session {
	mut data := urlencode(args)!
	// data = format(data, '')!
	response := client.post_request('checkout/sessions', data)!
	return json.decode(Session, response)
}

pub fn (client StripeClient) get_session_items(session_id string) ![]LineItem {
	// mut data := urlencode(args)!
	// data = format(data, '')!
	response := client.get_request('checkout/sessions/${session_id}/line_items?limit=10')!
	return json.decode([]LineItem, response)
}
