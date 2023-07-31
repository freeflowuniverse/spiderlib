module email

fn test_send_link() {
	authenticator := new()
	authenticator.send_link('test@email.com')
}
