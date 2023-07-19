module tfpayments

import vweb
import freeflowuniverse.crystallib.threefold.twinclient { TwinClient }
import freeflowuniverse.spiderlib.payments.stripeclient { StripeClient, Customer, LineItem, Session, Event }
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }
import json

// application controlling payments, fulfills order
struct PaymentApp {
	twinclient TwinClient
	stripeclient StripeClient
	call_channel chan FunctionCall
	resp_channel chan FunctionResponse
	host string = 'localhost'
	mut:
	orders map[string]Order
}

// order represents item ordered in succesfull checkout session
struct Order {
	pub:
	id string
	status OrderStatus
	item LineItem // lineitem corresponding to order
	customer Customer
}

enum OrderStatus {
	pending
	fulfilled
}

// main runs api and cli, listens for function calls from api's and cli's channels,
// handles received function calls, sends response over respective channels
fn main() {
	mut app := &PaymentApp{
		stripeclient: StripeClient{}
		twinclient: TwinClient{}
		call_channel: chan FunctionCall{cap: 100}
		resp_channel: chan FunctionResponse{cap: 100}
	}

	mut api := &PaymentAPI{
		call_channel: app.call_channel
		resp_channel: app.resp_channel
	}

	cli := PaymentCLI {
		call: app.call_channel
		resp: app.resp_channel
	}

	// concurrently run app, api and cli
	go app.run()
	go vweb.run(api, 4242)
	go cli.run()

	for{}
}

struct MastadonSessionArgs {
	cancel_url string
	success_url string
	quantity int
}

fn (mut app PaymentApp) run() {

	for {
		// receive function calls
		call := <- app.call_channel		
		mut resp := FunctionResponse{
			thread_id: call.thread_id
			function: call.function
		}

		// function call handler
		match call.function {
			// 'add_host' {
			// 	resp.payload = app.add_host(call.payload)
			// }
			// 'remove_host' {
			// 	resp.payload = app.remove_host(call.payload)
			// } 
			'create_mastadon_session' {
				args := json.decode(MastadonSessionArgs, call.payload) or {panic('')}
				session_url := app.create_mastadon_session(args)
				resp.payload = session_url
			}
			'handle_event' {
				event := app.stripeclient.decode_event(call.payload) or {panic(err)}
				app.handle_event(event)
			} else {}
		}
		app.resp_channel <- resp // send response
	}
}

// handle event receives stripe events
// fetches information about event, and fulfills orders accordingly
fn (mut app PaymentApp) handle_event(event Event) {
	// todo: handle more stripe events
	match event.eventtype {
		'checkout.session.complete' {
		// payment checkout has been complete
			session := event.data.object as Session
			if session.payment_status == .paid {
				// payment made, fulfill order
				app.fulfill_order(session) or {panic('err$err')}
			}
		} else {}
	} 
}

fn (mut app PaymentApp) fulfill_order(session Session) ! {
	items := app.stripeclient.get_session_items(session.id)! // fetch orders

	// fetch checkout items, add to orders, fulfill
	for item in items {
		
		// add order to orders
		order := Order {
			id: session.id
			item: item
			status: .pending
			customer: app.stripeclient.get_customer(session.customer)
		}
		app.orders[session.id] = order


		// call matching fulfiller
		if item.product == 'mastadon_server_month' {

			// get twinid of customer 
			app.fulfill_mastadon_order(order)!
		}
		// else if item.product == 'ourphone' {
			// fulfill_ourphone_order()! // future
		// }
	}
	// todo: set_order_fulfilled
}
