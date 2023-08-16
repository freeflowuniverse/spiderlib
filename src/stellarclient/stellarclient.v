module stellarclient

import json
import net.http
import time

pub struct Asset {
	code       string
	issuer     string
	asset_type AssetType
}

pub enum AssetType {
	credit_alphanum4
}

pub fn get_asset(code string, issuer string) !string {
	request := http.Request{
		url: 'https://horizon.stellar.org/assets?asset_code=${code}&asset_issuer=${issuer}'
		method: http.Method.get
	}
	result := request.do()!
	return result.body
}

pub fn get_orderbook(buying_asset Asset, selling_asset Asset) !string {
	request := http.Request{
		url: 'https://horizon.stellar.org/order_book?buying_asset_type=${buying_asset.asset_type}&buying_asset_code=${buying_asset.code}&buying_asset_issuer=${buying_asset.issuer}&selling_asset_type=${selling_asset.asset_type}&selling_asset_code=${selling_asset.code}&selling_asset_issuer=${selling_asset.issuer}'
		method: http.Method.get
	}
	result := request.do()!
	return result.body
}

pub fn get_trade_aggregation(base_asset Asset, counter_asset Asset, period i64) !TradeAggregation {
	start_time := time.now().unix - period
	request := http.Request{
		url: 'https://horizon.stellar.org/trade_aggregations?base_asset_type=${base_asset.asset_type}&base_asset_code=${base_asset.code}&base_asset_issuer=${base_asset.issuer}&counter_asset_type=${counter_asset.asset_type}&counter_asset_code=${counter_asset.code}&counter_asset_issuer=${counter_asset.issuer}&resolution=${period * 1000}&start_time=${start_time * 1000}&end_time=${time.now().unix * 2000}'
		method: http.Method.get
	}
	result := request.do()!
	println(result)
	return json.decode(TradeAggregation, result.body)
}

pub struct TradeAggregation {
pub:
	links    map[string]map[string]string [json: _links]
	embedded Embedded                     [json: _embedded]
}

pub struct Embedded {
pub:
	records []AggregationRecord
}

pub struct AggregationRecord {
pub:
	timestamp      string
	trade_count    string
	base_volume    string
	counter_volume string
	avg            string
	high           string
	high_r         TradeRecord
	low            string
	low_r          TradeRecord
	open           string
	open_r         TradeRecord
	close          string
	close_r        TradeRecord
}

pub struct TradeRecord {
	n string
	d string
}

// struct HorizonResponse {
// 	_links: Links

// }

// struct Asset {
//   _links: Links
//   _embedded: {
//     "records": [
//       {
//         "_links": {
//           "toml": {
//             "href": "https://threefold.io/.well-known/stellar.toml"
//           }
//         },
//         "asset_type": "credit_alphanum4",
//         "asset_code": "TFT",
//         "asset_issuer": "GBOVQKJYHXRR3DX6NOX2RRYFRCUMSADGDESTDNBDS6CDVLGVESRTAC47",
//         "paging_token": "TFT_GBOVQKJYHXRR3DX6NOX2RRYFRCUMSADGDESTDNBDS6CDVLGVESRTAC47_credit_alphanum4",
//         "num_accounts": 21165,
//         "num_claimable_balances": 3,
//         "num_liquidity_pools": 13,
//         "amount": "821557728.6303830",
//         "accounts": {
//           "authorized": 21165,
//           "authorized_to_maintain_liabilities": 0,
//           "unauthorized": 0
//         },
//         "claimable_balances_amount": "155.0000001",
//         "liquidity_pools_amount": "2465153.5271111",
//         "balances": {
//           "authorized": "821557728.6303830",
//           "authorized_to_maintain_liabilities": "0.0000000",
//           "unauthorized": "0.0000000"
//         },
//         "flags": {
//           "auth_required": false,
//           "auth_revocable": false,
//           "auth_immutable": false,
//           "auth_clawback_enabled": false
//         }
//       }
//     ]
//   }
// }
// }

// struct Links {
// 	self string
// 	next string
// 	prev string
// }
