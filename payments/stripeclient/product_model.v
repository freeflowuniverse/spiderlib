module stripeclient

import time

struct Product {
	id                   string
	object               string = 'product'
	active               bool   = true
	created              time.Time
	default_price_data   Price
	description          string
	images               []string
	livemode             bool
	metadata             map[string]string
	name                 string            [required]
	package_dimensions   string
	shippable            bool
	statement_descriptor string
	tax_code             string
	unit_label           string
	updated              time.Time
	url                  string
}

// arguments for creating a new product
struct ProductArgs {
	id          string
	name        string            [required]
	active      bool = true
	description string
	metadata    map[string]string
	// default_price_data   PriceArgs
	images               []string
	statement_descriptor string
	tax_code             string
	unit_label           string
	url                  string
}
