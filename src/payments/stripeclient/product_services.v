module stripeclient

import json
import net.http
import time

pub fn (client StripeClient) create_product(args ProductArgs) !Product {
	data := format(json.encode(args), '') or { '' }
	response := client.post_request('products', data)!
	return json.decode(Product, response)
}

pub fn (client StripeClient) retrieve_product(product_id string) !Product {
	response := client.get_request('products/${product_id}')!
	return json.decode(Product, response)
}
