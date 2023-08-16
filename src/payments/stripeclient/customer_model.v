module stripeclient

import time

pub struct Customer {
pub:
	id                    string
	object                string
	address               string
	balance               int
	created               time.Time
	currency              string
	default_source        string
	delinquent            bool
	description           string
	discount              string
	email                 string
	invoice_prefix        string
	invoice_settings      InvoiceSettings
	livemode              bool
	metadata              map[string]string
	name                  string
	next_invoice_sequence int
	phone                 string
	preferred_locales     []string
	shipping              string
	tax_exempt            string
	test_clock            string
}

struct InvoiceSettings {
	custom_fields          string
	default_payment_method string
	footer                 string
	rendering_options      string
}
