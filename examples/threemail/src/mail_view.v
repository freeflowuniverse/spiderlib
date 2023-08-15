module main

import freeflowuniverse.spiderlib.uikit.flowbite
import vweb

[middleware: with_user]
pub fn (mut app App) inbox() !vweb.Result {
	user_id := app.get_value[string]('user_id') or { return app.unauthorized() }
	page := flowbite.MailboxPage{
		title: 'Inbox'
		emails: app.get_emails(user_id, 'inbox')!
	}
	return app.html(page.html())
}

[middleware: with_user]
pub fn (mut app App) outbox() !vweb.Result {
	user_id := app.get_value[string]('user_id') or { return app.unauthorized() }
	page := flowbite.MailboxPage{
		title: 'Outbox'
		emails: app.get_emails(user_id, 'outbox')!
	}
	return app.html(page.html())
}

// ['/email/:id'; middleware: with_user]
// pub fn (mut app App) email(id string) vweb.Result {
// 	page := flowbite.EmailPage{
// 		email: app.user.emails[id]
// 	}
// 	return app.html(page.html())
// }

// pub fn (mut app App) compose() vweb.Result {
// 	page := flowbite.ComposePage{}
// 	return app.html(page.html())
// }

// [POST; middleware: with_user]
// pub fn (mut app App) send() vweb.Result {

// 	// page := flowbite.SentPage{}
// 	return app.html('sent')
// }
