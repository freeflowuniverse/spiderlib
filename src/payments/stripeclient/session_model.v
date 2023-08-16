module stripeclient

import time

pub struct Session {
pub:
	id                         string
	object                     string = 'checkout.session'
	after_expiration           map[string]string
	allow_promotion_codes      string
	amount_subtotal            string
	amount_total               string
	automatic_tax              AutomaticTax
	billing_address_collection string
	cancel_url                 string
	client_reference_id        string
	consent                    string
	consent_collection         string
	created                    time.Time
	currency                   Currency
	custom_text                CustomText
	customer                   string
	customer_creation          string
	customer_email             string
	expires_at                 time.Time
	invoice                    string
	invoice_creation           string
	livemode                   bool
	locale                     string
	metadata                   map[string]string
	mode                       SessionMode
	payment_intent             string
	payment_link               string
	payment_method_collection  string
	payment_method_options     map[string]string
	// payment_method_types []PaymentMethodType
	payment_status              PaymentStatus
	phone_number_collection     PhoneNumberCollection
	recovered_from              string
	redaction                   string
	setup_intent                string
	shipping_address_collection string
	shipping_cost               string
	shipping_details            string
	shipping_options            []string
	status                      SessionStatus
	submit_type                 string
	subscription                string
	success_url                 string
	total_details               string
	url                         string
}

struct AutomaticTax {
	enabled bool
	status  string
}

struct CustomText {
	shipping_address string
	submit           string
}

struct CustomerDetails {
	address    string
	email      string
	name       string
	phone      string
	tax_exempt string
	tax_ids    string
}

enum SessionMode {
	payment
	setup
	subscription
}

enum PaymentMethodType {
	card
}

pub enum PaymentStatus {
	unpaid
	paid
}

struct PhoneNumberCollection {
	enabled bool
}

enum SessionStatus {
	expired
}

pub struct SessionArgs {
	cancel_url string [required]
	// todo: find a way to convertt enum to str in encoding
	// mode SessionMode
	mode                  string
	success_url           string            [required]
	after_expiration      map[string]string
	allow_promotion_codes string
	amount_subtotal       string
	amount_total          string
	line_items            []LineItem
}

pub struct LineItem {
pub:
	price string
	// price_data          PriceArgs
	quantity            int
	adjustable_quantity map[string]string
	dynamic_tax_rates   string
	tax_rates           string
	product             string
}
