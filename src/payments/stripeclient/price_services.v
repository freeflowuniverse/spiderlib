module stripeclient

import x.json2
import json

// Price services for stripe
// see https://stripe.com/docs/api/prices/

// create price creates a new price object on stripe.
pub fn (client StripeClient) create_price(args PriceArgs) !Price {
	mut data := urlencode(args)!
	response := client.post_request('prices', data) or { panic('Failed to create price: ${err}') }

	price := json.decode(Price, response)!
	$if debug {
		eprintln('Created new price: ${price}')
	}

	return price
}

// update price updates an existing price object on stripe.
// passed parameters are updated
pub fn (client StripeClient) update_price(id string, args PriceArgs) !Price {
	mut data := urlencode(args)!
	response := client.post_request('prices/${id}', data) or {
		panic('Failed to update price: ${err}')
	}

	price := json.decode(Price, response)!
	$if debug {
		eprintln('Updated price: ${price}')
	}

	return price
}
