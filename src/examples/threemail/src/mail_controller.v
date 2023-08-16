module main

import freeflowuniverse.spiderlib.uikit.flowbite

pub fn (mut app App) get_emails(user_id string, mailbox_id string) ![]flowbite.Email {
	rlock app.users {
		mailbox := app.users[user_id].mailboxes[mailbox_id]
		emails := mailbox.emails.map(flowbite.Email{
			subject: it.subject
		})
		return emails
	}
	return []
}
