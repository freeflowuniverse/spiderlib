module main

import vweb
import freeflowuniverse.crystallib.threefold.twinclient { TwinClient }
import freeflowuniverse.spiderlib.payments.stripeclient { StripeClient }
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }

struct Server {
	vweb.Context
	twinclient TwinClient
	stripeclient StripeClient
	host string = 'localhost'
	call_channel chan FunctionCall [vweb_global]
	resp_channel chan FunctionResponse [vweb_global]
}

// stripe webhook endpoint listens to events from stripe, authenticates,
// and passes events to PaymentApi over channel for handling
[post]
pub fn (mut server Server) stripe_webhook() vweb.Result {
	$if debug {
		println('Incoming webhook data: $server.req.data')
	}

	// event := server.stripeclient.decode_event(server.req.data) or {
	// 	eprintln('Failed to decode event: $err')
	// 	return server.server_error(500)
	// }

	function_call := FunctionCall {
		function: 'handle_event'
		payload: app.req.data
	}

	// pass event and return quick 200 response
	server.call_channel <- function_call
	return server.html('ok') 
}

// create payment url receives the number of months of mastadon server to be purchased
// returns session url to be redirected for stripe payment
pub fn (mut server Server) create_mastadon_session() vweb.Result {
	function_call := FunctionCall {
		function: 'create_mastadon_session'
		payload: server.req.data
	}
	app.call_channel <- function_call
	response := <- app.resp_channel
	session := json.decode(CheckoutSession, response.payload)
	return app.text(session.url)
}