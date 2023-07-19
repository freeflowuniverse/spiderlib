module tfpayments

import freeflowuniverse.spiderlib.stellarclient
import vweb


fn get_tft_price() !f64 {
	// get current daily high price of tft / usdc
	base := stellarclient.Asset {
		code: 'TFT'
		issuer: 'GBOVQKJYHXRR3DX6NOX2RRYFRCUMSADGDESTDNBDS6CDVLGVESRTAC47'
	}
	counter := stellarclient.Asset {
		code: 'USDC'
		issuer: 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN'
	}
	// use 1 day trade aggregation to get high price
	aggregation := stellarclient.get_trade_aggregation(base, counter, 86400)!
	return aggregation.embedded.records[0].high.f64()
}
// // create payment url creates a url to be redirected for stripe payment
// pub fn (mut app App) mastadon_payment_success() vweb.Result {
// 	// data := 
// 	// tft_price := app.stellarclient.get_price(tft, usd)

// 	// address_dest := ""

// 	// response := app.twinclient.stellar_pay(
// 	// 	'mastadon_server',
// 	// 	address_dest,
// 	// 	amount,
// 	// 	tft,
// 	// 	'Mastadon server fee'
// 	// )


// 	args := SessionArgs {
// 		cancel_url: '$app.host/callback_cancel'
// 		success_url: '$app.host/callback_cancel'
// 		line_items: LineItem {
// 			price_data PriceArgs {
// 				currency: 'usd'
// 				product: 'mastadon_server_month'
// 				amount: 'args.unit_amount'
// 			}
// 		}
// 	}
// 		println(app.req)
// 	return app.html('ook')
// 	// app.stripeclient.create_session()
// }