module main

import freeflowuniverse.spiderlib.uikit.flowbite
import freeflowuniverse.spiderlib.htmx
import vweb
import net.http

pub fn (mut app App) login() vweb.Result {
	page := flowbite.login_page(
		route: '/send_verification_email'
		// tfconnect_url: app.tfconnect_client.create_login_url()
	)
	return app.html(page.html())
}

pub fn (mut app App) register() vweb.Result {
	page := flowbite.SignUp{}
	return app.html(page.html())
}

pub fn (mut app App) unauthorized() vweb.Result {
	app.set_status(401, '')
	return app.text('HTTP 401: Unauthorized')
}

[POST]
pub fn (mut app App) send_verification_email() vweb.Result {
	data := http.parse_form(app.req.data)
	email := data['email']
	app.email_client.send_verification_email(data['email']) or {
		return app.html('Failed to send email')
	}
	alert := flowbite.AdditionalContent{
		alert: 'Verification email sent to ${data['email']}'
		// htmx that triggers a get request to get the resulting view of email verification
		htmx: htmx.HTMX{
			get: '/email_verification_result/${data['email']}'
			trigger: 'load'
			target: 'this'
			swap: 'outerHTML'
		}
		content: "You should receive a verification email from auth@authenticator.io. You have 180 seconds to verify your email. If you haven't received an email please try click resend or login with TFConnect."
		buttons: [
			struct {
				label: 'Resend'
				action: htmx.HTMX{
					post: '/send_verification_email'
					vals: '{"email": "${email}"}'
				}
			},
		]
	}
	return app.html('<div hx-get="/email_verification_result">${alert.html()}</div>')
}

['/email_verification_result/:email']
pub fn (mut app App) email_verification_result(email string) !vweb.Result {
	app.email_client.is_verified(email) or { return app.html('Failed to send email') }
	alert := flowbite.AdditionalContent{
		alert: 'Verified ${email}'
		status: .success
		content: 'Welcome to 3Mail, ${email}. Your email have been successfully verified and you can now start receiving and sending emails!.'
	}
	user_id := app.register_user(email: email)
	app.save_session(user_id) or { panic(err) }
	app.add_header('HX-Trigger', 'login')
	return app.html(alert.html())
}

['/verification_link/:address/:cypher']
pub fn (mut app App) verification_link(address string, cypher string) !vweb.Result {
	result := app.email_client.authenticate(address, cypher)!
	if result.authenticated {
		return app.html('Email ${address} successfully verified!')
	}
	return app.html('Email verification failed.')
}

// pub fn (mut app App) tfconnect_callback() vweb.Result {
// 	page := spider.IPage()
// 	return app.html(page.html())
// }
