module view

import vweb
import ui_kit { Button, Dashboard, Navbar, Sidebar }
import freeflowuniverse.spiderlib { HTMX }

// router to catch and redirect dashboard routes
['/dashboard/:route...']
pub fn (mut app App) dashboard_(route string) vweb.Result {
	return app.dashboard()
}

// returns dashboard with child page according to route
pub fn (mut app App) dashboard() vweb.Result {

	navbar := Navbar {
		logo_path: '#'
		username: app.user.name
	}

	dashboard := Dashboard{
		logo_path: '#'
		navbar: navbar
		sidebar: '/dashboard_sidebar'
	}

	// app.add_header('HX-Push', '/dashboard/home')
	return app.html(dashboard.render())
}

pub fn (mut app App) dashboard_sidebar() vweb.Result {
	home_btn := Button{
		label: 'Home'
		icon: '#'
		hx: HTMX{
			get: '/home'
			target: '#dashboard-container'
		}
	}

	sites_btn := Button{
		label: 'Sites'
		icon: '#'
		hx: HTMX{
			get: '/sites'
			target: '#dashboard-container'
		}
	}

	sidebar := Sidebar{
		menu: [
			home_btn,
			sites_btn,
		]
	}
	return $vweb.html()
}
