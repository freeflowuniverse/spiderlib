module jwt

// creates user jwt cookie, enables session keeping
fn test_create_token() {
	token := create_token('tokendata')
	panic(token)
}
