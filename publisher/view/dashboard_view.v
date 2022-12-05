module view

import vweb
import freeflowuniverse.spiderlib.uikit.shell { Dashboard }
import freeflowuniverse.spiderlib.uikit.partials { DashboardNavbar, DashboardSidebar }
import freeflowuniverse.spiderlib.uikit.elements { IconButton }
import freeflowuniverse.spiderlib.htmx { HTMX }

// router to catch and redirect dashboard routes
['/dashboard/:route...']
pub fn (mut app App) dashboard_(route string) vweb.Result {
	return app.dashboard()
}

// returns dashboard with child page according to route
pub fn (mut app App) dashboard() vweb.Result {

	navbar := DashboardNavbar {
		logo_path: '#'
		username: app.user.name
	}

	sidebar := DashboardSidebar{
		menu: [
			IconButton{
				label: 'Home'
				icon: '#'
				hx: htmx.navigate('/home')
			},
			IconButton{
				label: 'Sites'
				icon: '#'
				hx: htmx.navigate('/sites')
			}
		]
	}

	dashboard := Dashboard{
		logo_path: '#'
		navbar: navbar
		sidebar: sidebar
	}

	return app.html(dashboard.render())
}