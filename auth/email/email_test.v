module email

import log
import os
import net.smtp
import toml

struct SmtpCredentials {
	username string
	password string
}

const credentials = parse_env() 

fn parse_env() SmtpCredentials {
	toml.parse_file(os.dir(os.dir(@FILE)) + '/.env')
	return SmtpCredentials{
		username: env.value('SMTP_USERNAME').string()
		password: env.value('SMTP_PASSWORD').string()
	}
}

fn test_new() {
	mut logger := log.Logger(&log.Log{
		level: .debug
	})

	smtp_client := smtp.new_client{
		server: 'smtp-relay.brevo.com'
		from: 'verify@authenticator.io'
		port: 587
		username: credentials.username
		password: credentials.password
	}

	verification_mail := VerificationMail {
		subject: 'Test Subject'
		body: 'Test body'
	}

	authenticator := new(
		client: smtp_client
		mail: verification_mail
	)
}

fn test_send_link() {

	// authenticator.send_link('test@email.com')
}
