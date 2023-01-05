module stripeclient

import time

type RecurringOptional = Recurring | int

pub struct Price {
	pub:
	id                 string
	object             string = 'price'
	active             bool   = true
	billing_scheme     BillingScheme
	created            time.Time
	currency           string // Currency
	custom_unit_amount int
	livemode           bool
	lookup_key         string
	metadata           map[string]string
	nickname           string
	product            string
	recurring          Recurring
	unit_amount        int
	product_data       ProductArgs
	// todo: add remaining fields
}

pub struct PriceArgs {
	currency           string // Currency [required]
	product            string
	unit_amount        int
	active             bool
	metadata           map[string]string
	nickname           string
	recurring          Recurring
	custom_unit_amount int
	billing_scheme     BillingScheme
	// todo: add remaining fields
}

[params]
struct Recurring {
	interval        Interval
	aggregate_usage AggregateUsage = .sum
	interval_count  int
	usage_type      UsageType = .licensed
}

enum Interval {
	day
	week
	month
	year
}

enum AggregateUsage {
	sum
	last_during_period
	last_ever
	max
}

enum UsageType {
	licensed
	metered
}

enum BillingScheme {
	per_unit
	tiered
}
