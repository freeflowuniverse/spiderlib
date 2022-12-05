module partials

import freeflowuniverse.spiderlib.htmx { HTMX}
import freeflowuniverse.spiderlib.uikit.elements { Button}

type Navbar = DashboardNavbar

// pub struct Navbar {
// pub mut:
// 	logo_path string
// 	username  string
// }

pub struct DashboardNavbar {
pub mut:
	logo_path string // path of application logo
	username  string // username for display
	login_path string // path to login controller
}

// pub fn (navbar Navbar) render() string {
// 	current_url:= '/home'
// 	return $tmpl('templates/navbar.html')
// }

pub fn (navbar DashboardNavbar) render() string {
	current_url:= '/home'

	mut user_btn := elements.RoundedButton {}

	// displays login button if there isn't user
	if navbar.username != '' {
		user_btn.label = navbar.username
	} else {
		user_btn.label = 'Login'
		user_btn.hx = HTMX {
			get: '/login'
			target: '#dashboard-container'
		}
	}

	return $tmpl('templates/navbar.html')
}