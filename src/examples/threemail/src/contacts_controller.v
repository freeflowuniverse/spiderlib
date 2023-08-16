module main

import freeflowuniverse.spiderlib.uikit.flowbite
import vweb

pub fn (mut app App) get_contacts(user_id string) ![]flowbite.User {
	rlock app.users {
		contacts := app.users[user_id].contacts
		users := contacts.map(flowbite.User{
			name: it.name
			email: it.email
			country: it.country
		})
		return users
	}
	return []
}

pub fn (mut app App) controller_add_contact(user_id string, contact Contact) ! {
	lock app.users {
		app.users[user_id].contacts << contact
	}
}
