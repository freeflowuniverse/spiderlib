import vweb
import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.uikit.flowbite
import os
// import freeflowuniverse.spiderlib.uikit2.tailwindui.sidebar {LightSidebar, Link}

pub fn (mut app App) index() vweb.Result {
	profile_button := flowbite.NavButton{
		label: 'Sign In'
		logo: 'dashboard'
		route: '/login'
	}

	navbar := flowbite.Navbar{
		logo: 'logo'
		// search_htmx: htmx.HTMX{}
		nav: [
			flowbite.DropdownButton{
				tooltip: 'Notifications'
				logo: '/notifications'
				dropdown: flowbite.NotificationDropdown{}
			},
			flowbite.DropdownButton{
				tooltip: 'Apps'
				logo: 'apps'
				dropdown: flowbite.AppsDropdown{}
			},
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
		]
	}

	footer := flowbite.Footer{}
	shell := flowbite.Shell{
		navbar: navbar
		sidebar: sidebar
		footer: footer
		router: {
			'/': '/home'
		}
	}

	index := uikit.Index{
		scripts: ['/static/js/htmx.min.js']
		stylesheets: ['/static/css/index.css']
		shell: shell
	}
	return $vweb.html()
}
