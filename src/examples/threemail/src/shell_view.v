module main

import vweb
import freeflowuniverse.spiderlib.uikit.flowbite
import freeflowuniverse.spiderlib.htmx

pub fn (mut app App) before_request() {
	// redirects non-htmx requests to index
	hx_request := app.get_header('Hx-Request') == 'true'

	if !hx_request && app.req.url != '/' && !app.req.url.ends_with('.js')
		&& !app.req.url.ends_with('.css') && !app.req.url.starts_with('/verification_link')
		&& !app.req.url.starts_with('/email_verification') {
		app.add_header('Hx-Push-Url', app.req.url)
		app.redirect('/')
	}
}

pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

[middleware: get_user]
pub fn (mut app App) shell() !vweb.Result {
	mut profile_button := flowbite.NavButton{
		id: 'profile-btn'
		label: 'Sign In'
		logo: 'dashboard'
		route: '/login'
		htmx: htmx.HTMX{
			trigger: 'login from:body'
			get: '/shell'
			select_: '#profile-btn'
			target: 'this'
		}
	}

	if user_id := app.get_value[string]('user_id') {
		if user := app.controller_get_user(user_id) {
			profile_button = flowbite.NavButton{
				id: 'profile-btn'
				label: user.email
				logo: 'dashboard'
				route: '/profile'
			}
		}
	}

	navbar := flowbite.Navbar{
		logo: 'logo'
		// search_htmx: htmx.HTMX{}
		nav: [
			// flowbite.DropdownButton{
			// 	tooltip: 'Notifications'
			// 	logo: '/notifications'
			// 	dropdown: flowbite.NotificationDropdown{}
			// },
			// flowbite.DropdownButton{
			// 	tooltip: 'Apps'
			// 	logo: 'apps'
			// 	dropdown: flowbite.AppsDropdown{}
			// },
			profile_button,
			// flowbite.ProfileDropdown{},
		]
	}
	sidebar := flowbite.Sidebar{
		nav: [
			flowbite.NavButton{
				label: 'Dashboard'
				logo: 'dashboard'
				route: '/dashboard'
			},
			flowbite.NavButton{
				label: 'Inbox'
				logo: 'inbox'
				route: '/inbox'
			},
			flowbite.NavButton{
				label: 'Contacts'
				logo: 'contact'
				route: '/contacts'
			},
		]
	}

	footer := flowbite.Footer{}
	mut shell := flowbite.Shell{
		navbar: navbar
		sidebar: sidebar
		footer: footer
		router: {
			'': '/inbox'
		}
	}
	shell.route = shell.router[app.req.url.all_after('/shell')]
	return app.html(shell.html())
}

// pub fn (mut app App) not_found() vweb.Result {
// 	page := flowbite.NotFoundPage{
// 		title: ''
// 		content: ''
// 		button: ''
// 		link: ''
// 	}
// 	return app.html(page.html())
// }
