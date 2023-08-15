module main

import freeflowuniverse.spiderlib.uikit.flowbite
import freeflowuniverse.spiderlib.htmx
import net.http
import vweb

[middleware: with_user]
pub fn (mut app App) contacts() !vweb.Result {
	user_id := app.get_value[string]('user_id') or { return app.unauthorized() }
	page := flowbite.UsersPage{
		users: app.get_contacts(user_id)!
		add_button: struct {
			label: 'Add Contact'
			htmx: htmx.HTMX{
				get: '/add_contact_modal'
				swap: 'afterend'
				target: '#users-page'
			}
		}
	}
	return app.html(page.html())
}

pub fn (mut app App) add_contact_modal() !vweb.Result {
	modal := flowbite.AddUserModal{
		form_htmx: htmx.HTMX{
			post: '/add_contact'
			target: '#outlet'
		}
	}
	return app.html(modal.html())
}

[middleware: with_user]
[POST]
pub fn (mut app App) add_contact() !vweb.Result {
	user_id := app.get_value[string]('user_id') or { return app.unauthorized() }
	data := http.parse_form(app.req.data)
	contact := Contact{
		name: '${data['first-name']} ${data['last-name']}'
		email: data['email']
		country: data['country']
	}
	app.controller_add_contact(user_id, contact)!
	return app.contacts()
}
