module email

import log
import os
import net.smtp
import toml


fn get_email() !string {
	env := toml.parse_file(os.dir(@FILE) + '/.env')!
	return env.value('EMAIL').string()
}

fn get_credentials() !(string, string) {
	env := toml.parse_file(os.dir(@FILE) + '/.env')!
	username:= env.value('SMTP_USERNAME').string()
	password:= env.value('SMTP_PASSWORD').string()
	return username, password
}

fn test_new() {
	mut logger := log.Logger(&log.Log{
		level: .debug
	})
	authenticator := new(
		logger: &logger
		backend: new_memory_backend()!
	)
}

fn test_send_verification_mail() {
	mut logger := log.Logger(&log.Log{
		level: .debug
	})
	mut authenticator := new(
		logger: &logger
		backend: new_memory_backend()!
	)

	username, password := get_credentials()!
	smtp_config := SmtpConfig{
		server: 'smtp-relay.brevo.com'
		from: 'verify@authenticator.io'
		port: 587
		username: username
		password: password
	}
	verification_mail := VerificationMail{
		subject: 'test_send_verification_mail'
		body: 'Test body'
	}

	authenticator.send_verification_mail(
		email: get_email()!
		smtp: smtp_config
		mail: verification_mail
		link: 'https://example.com'
	)!
}
