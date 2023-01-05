module main

import vweb
import json
import freeflowuniverse.crystallib.threefold.twinclient { TwinClient }
import freeflowuniverse.spiderlib.payments.stripeclient { StripeClient, Session }
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }

struct PaymentAPI {
	vweb.Context
	twinclient TwinClient
	stripeclient StripeClient
	host string = 'localhost'
	call_channel chan FunctionCall [vweb_global]
	resp_channel chan FunctionResponse [vweb_global]
}

pub fn (mut api PaymentAPI) before_request() {
	println(api.req)
}

// stripe webhook endpoint listens to events from stripe, authenticates,
// and passes events to PaymentApi over channel for handling
[post]
pub fn (mut api PaymentAPI) stripe_webhook() vweb.Result {
	$if debug {
		println('Incoming webhook data: $api.req.data')
	}

	// event := api.stripeclient.decode_event(api.req.data) or {
	// 	eprintln('Failed to decode event: $err')
	// 	return api.server_error(500)
	// }

	function_call := FunctionCall {
		function: 'handle_event'
		payload: api.req.data
	}

	// pass event and return quick 200 response
	api.call_channel <- function_call
	return api.html('ok') 
}

// create payment url receives the number of months of mastadon api to be purchased
// returns session url to be redirected for stripe payment
[POST]
pub fn (mut api PaymentAPI) create_mastadon_session() vweb.Result {
	function_call := FunctionCall {
		function: 'create_mastadon_session'
		payload: api.req.data
	}
	api.call_channel <- function_call
	response := <- api.resp_channel
	session := json.decode(Session, response.payload) or {panic(err)}
	return api.text(session.url)
}