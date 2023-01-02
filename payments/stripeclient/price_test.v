module stripeclient

__global (
	client StripeClient
)

fn testsuite_begin() {
	client = StripeClient{
		sk_test: 'enter secret test key'
	}
}

fn test_create_price() ! {
	test_price := client.create_price(
		nickname: 'testprice'
		currency: 'usd'
		product: 'testproduct'
		unit_amount: 1
	) or { panic('err: ${err}') }
	assert test_price.id.starts_with('price_')
	assert test_price.nickname == 'testprice'
	assert test_price.product == 'testproduct'
	assert test_price.unit_amount == 1
	assert test_price.currency == 'usd'
}

fn test_update_price() ! {
	test_price := client.create_price(
		nickname: 'testprice'
		currency: 'usd'
		product: 'testproduct'
		unit_amount: 1
	) or { panic('err: ${err}') }

	updated_price := client.update_price(
		test_price.id,
		active: true
		nickname: 'updatedprice'
		metadata: {'updated': 'metadata'}
	) or { panic('err: ${err}') }

	assert updated_price.id == test_price.id
	assert updated_price.nickname == 'updatedprice'
	assert updated_price.metadata == {'updated': 'metadata'}
}
