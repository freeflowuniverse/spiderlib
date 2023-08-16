module stellarclient

import time

fn test_get_asset() ! {
	asset := get_asset('TFT', 'GBOVQKJYHXRR3DX6NOX2RRYFRCUMSADGDESTDNBDS6CDVLGVESRTAC47')!
	// panic(asset)
}

fn test_get_orderbook() ! {
	buying := Asset{
		code: 'TFT'
		issuer: 'GBOVQKJYHXRR3DX6NOX2RRYFRCUMSADGDESTDNBDS6CDVLGVESRTAC47'
	}
	selling := Asset{
		code: 'USDC'
		issuer: 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN'
	}
	orderbook := get_orderbook(buying, selling)!
	// panic(orderbook)
}

fn test_get_trade_aggregation() ! {
	base := Asset{
		code: 'TFT'
		issuer: 'GBOVQKJYHXRR3DX6NOX2RRYFRCUMSADGDESTDNBDS6CDVLGVESRTAC47'
	}
	counter := Asset{
		code: 'USDC'
		issuer: 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN'
	}
	aggregation := get_trade_aggregation(base, counter, 86400)!
	panic(aggregation)
}
