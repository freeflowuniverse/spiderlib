module flowbite

import freeflowuniverse.spiderlib.htmx

pub struct ProfileNavbar {
	title string // title text displayed on the navbar
	logo string // path of the logo displayed on the navbar
	logged_in bool // whether the user is logged in
	login_url string // url of login page
	profile_name string // name displayed on profile button
	profile_image string // image of profile displayed on button
	profile_url string // url of profile page
}

pub fn profile_navbar(navbar ProfileNavbar) Navbar {

	btn_label, btn_url, btn_img := if navbar.logged_in {
		navbar.profile_name, navbar.profile_url, navbar.profile_image
	} else {
		'Log In', navbar.login_url, 'login'
	}
	
	profile_btn := flowbite.NavButton{
		label: 'Log In'
		logo: btn_img
		htmx: htmx.HTMX {
			get: btn_url
			target: '#outlet'
		}
	}

	return Navbar{
		logo: navbar.logo
		title: navbar.title
		nav: [
			profile_btn
		]
	}
}
			// route: '/login'
			// htmx: htmx.HTMX {
			// 	trigger: 'login from:body'
			// 	get: '/shell'
			// 	select_: '#profile-btn'
			// 	target: 'this'
			// }

