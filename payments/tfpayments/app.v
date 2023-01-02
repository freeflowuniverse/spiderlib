module main

import vweb
import freeflowuniverse.crystallib.threefold.twinclient { TwinClient }
import freeflowuniverse.spiderlib.payments.stripeclient { StripeClient }
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }

// application controlling payments, fulfills order
struct PaymentApp {
	twinclient TwinClient
	stripeclient StripeClient
	call_channel chan FunctionCall
	resp_channel chan FunctionResponse
	host string = 'localhost'
	orders map[string]Order
}

struct Order {
	id string
	status OrderStatus
	session Session // Checkout session corresponding to order
}

enum OrderStatus {
	pending
	fulfilled
}

// main runs server, listens for events from server's channel
// and concurrently passes events to handler
fn main() {
	app := PaymentApp{
		stripeclient: StripeClient{}
		twinclient: TwinClient{}
		call_channel: chan FunctionCall{cap: 100}
		resp_channel: chan FunctionResponse{cap: 100}
	}

	mut api := &PaymentAPI{
		call: app.call_channel
		resp: app.resp_channel
	}

	mut cli := &PaymentCLI{
		call: app.call_channel
		resp: app.resp_channel
	}

	go app.run()
	go vweb.run(api, 4242)
	go cli.run()
}

struct MastadonSessionArgs {
	cancel_url string
	success_url string
	quantity int
}

fn (app PaymentApp) run() {

	for {
		call := <- app.call_channel		
		mut resp := FunctionResponse{
			thread_id: call.thread_id
			function: call.function
		}

		match call.function {
			'add_host' {
				resp.payload = app.add_host(call.payload)
			}
			'remove_host' {
				resp.payload = app.remove_host(call.payload)
			} 'create_mastadon_session' {
				args := json.decode(MastadonSessionArgs, call.payload)!
				session_url := app.create_mastadon_session(args)
				resp.payload = session_url
			}
			'handle_event' {
				event := app.stripeclient.decode_event(call.payload)!
				resp.payload = app.handle_event(event)
			} else {}
		}
		app.resp_channel <- resp // send response
	}
}

// handle event receives stripe events
// fetches information about event, and fulfills orders accordingly
fn (app PaymentApp) handle_event(event Event) {
	// todo: handle more stripe events
	match event.event_type {
		'checkout.session.complete' {
		// payment checkout has been complete
			session := event.data.object
			if session.payment_status == 'paid' {
				// payment made, fulfill order
				return fulfill_order(event.data.object)
			}
		}
	} 
	return app.html('ok')
}

fn (app PaymentApp) fulfill_order(session Session) ! {
	items := stripe.get_session_items() // fetch orders

	// fetch checkout items, add to orders, fulfill
	for item in items {
		
		// add order to orders
		app.orders[session.id] = Order {
			id: session.id
			session: session
			status: .pending
		}

		// call matching fulfiller
		if item.product == 'mastadon_server_month' {
			fulfill_mastadon_order()!
		} else if item.product == 'mastadon_server_month' {
			fulfill_ourphone_order()!
		}
	}
	// todo: set_order_fulfilled
}
