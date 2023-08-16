module tfconnect

pub struct TFConnectClient {
	callback_url string
	scopes       []Scope
}

pub enum Scope {
	email
}

pub fn new_client() TFConnectClient {
	return TFConnectClient{}
}
