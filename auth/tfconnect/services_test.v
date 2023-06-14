module tfconnect

fn test_create_login_url() {
	authenticator := new(app_id: 'test')!
	url := authenticator.create_login_url()
}