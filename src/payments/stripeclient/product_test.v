module stripeclient

__global (
	client StripeClient
)

fn testsuite_begin() {
	client = StripeClient{
		sk_test: 'enter secret test key'
	}
}

fn test_create_product() {
	args := ProductArgs{
		name: 'testproduct'
	}
	test_product := client.create_product(args)!
	assert test_product.id.starts_with('prod_')
	assert test_product.name == 'testproduct'
}
