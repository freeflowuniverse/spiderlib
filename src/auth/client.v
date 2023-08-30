module auth

import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session

pub struct Client {
	email.EmailClient
	session.Client
}

[params]
pub struct ClientConfig {
	auth_server string [required]
}

pub fn new_client(config ClientConfig) Client {
	return Client{
		EmailClient: email.EmailClient{
			url: '${config.auth_server}/email_authenticator'
		}
		Client: session.Client{
			url: '${config.auth_server}/session_authenticator'
		}
	}
}


