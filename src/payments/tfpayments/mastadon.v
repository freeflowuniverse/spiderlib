module tfpayments

import freeflowuniverse.spiderlib.payments.stripeclient { LineItem }
import time

// create mastadon session receives the quantity of months for the mastadon server
// creates a checkout session for the mastadon server month product of given quantity
// returns the url of the checkout session
pub fn (mut app PaymentApp) create_mastadon_session(args MastadonSessionArgs) string {
	// create price for mastadon product with most recent price
	tft_amount := app.get_mastadon_fee()
	tft_price := get_tft_price() or { panic('err: ${err}') }
	usd_price := tft_price * tft_amount
	price := app.stripeclient.create_price(
		active: true
		nickname: 'mastadon_monthly_price_${time.now()}'
		currency: 'usd'
		product: 'mastadon_server_month'
		unit_amount: int(usd_price * 100) // price unit is cents
	) or { panic('Failed to create price: ${err}') }

	// create checkout session with new price and quantity
	session := app.stripeclient.create_session(
		cancel_url: args.cancel_url
		success_url: args.success_url
		line_items: [LineItem{
			price: price.id
			quantity: args.quantity
		}]
	) or { panic('Failed to create Stripe checkout session: ${err}') }

	$if debug {
		eprintln('Created Mastadon checkout session: ${session}')
	}

	return session.url
}

// get mastadon fee returns the latest fee of 1 month mastadon server in tfts
fn (app PaymentApp) get_mastadon_fee() int {
	// todo: calculate price from grid
	return 1000
}

// fulfill mastadon order receives the twinid which will receive
// the mastadon server service, and the quantity of months
fn (app PaymentApp) fulfill_mastadon_order(order Order) ! {
	twinid := order.customer.metadata['twinid']
	tft_amount := order.item.quantity * app.get_mastadon_fee() // total fee in tfts
	tft_price := get_tft_price()! // price of 1 tft in usdc
	usd_price := tft_price * tft_amount
}
