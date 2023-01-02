module stripeclient

import json
import maps
import net.http { Method }

pub struct StripeClient {
	sk_test string
}

enum Currency {
	aed
	usd
}

// returns json encoded string response body
fn (client StripeClient) post_request(endpoint string, data_ string) !string {
	// creates request, adds auth and content type header
	url := 'https://api.stripe.com/v1/${endpoint}'
	mut request := http.new_request(Method.post, url, data_) or {
		panic('Failed to create http request')
	}
	request.add_header(http.CommonHeader.authorization, 'Basic ${client.sk_test}')
	request.add_header(http.CommonHeader.content_type, 'application/x-www-form-urlencoded')
	println('reqqy: ${request}')
	response := request.do() or { panic('Failed to send request to API.') }
	// returns error if receives error response
	if response.body.contains('"error": {') {
		// todo: better error handling
		println('resp: ${response}')
		return error('fail')
	}
	return response.body
}

// returns json encoded string response body
fn (client StripeClient) get_request(endpoint string, data string) !string {
	// creates request, adds auth and content type header
	url := 'https://api.stripe.com/v1/${endpoint}${data}'
	mut request := http.new_request(Method.get, url, '') or {
		panic('Failed to create http request')
	}
	request.add_header(http.CommonHeader.authorization, 'Basic ${client.sk_test}')
	request.add_header(http.CommonHeader.content_type, 'application/x-www-form-urlencoded')

	response := request.do()!
	// returns error if receives error response
	if response.body.contains('"error": {') {
		// todo: better error handling
		return error('fail')
	}
	return response.body
}
