module flowbite

import freeflowuniverse.spiderlib.htmx { HTMX}
import freeflowuniverse.spiderlib.uikit.elements { Button}

pub struct Navbar {
pub mut:
	logo string // path of application logo
	menu []Button
}

pub struct NavItem {
	label string
	route string
}

// pub fn (navbar Navbar) render() string {
// 	current_url:= '/home'
// 	return $tmpl('templates/navbar.html')
// }

// pub fn (navbar DashboardNavbar) render() string {
// 	current_url:= '/home'

// 	mut user_btn := elements.RoundedButton {}

// 	// displays login button if there isn't user
// 	if navbar.username != '' {
// 		user_btn.label = navbar.username
// 	} else {
// 		user_btn.label = 'Login'
// 		user_btn.hx = HTMX {
// 			get: '/login'
// 			target: '#dashboard-container'
// 		}
// 	}

// 	return $tmpl('templates/navbar.html')
// }