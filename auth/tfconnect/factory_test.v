module tfconnect

fn test_new() {

	// test with keys
	authenticator0 := new(
		app_id: 'test'
		keypair: Keypair {
			public_key: 'test'
			private_key: 'test'
		}
	)!
	assert authenticator0.pk_decoded.len == 32
	assert authenticator0.sk_decoded.len == 64

	// test without predefined keys
	authenticator1 := new(app_id: 'test')!
	assert authenticator1.pk_decoded.len == 32
	assert authenticator1.sk_decoded.len == 64
}