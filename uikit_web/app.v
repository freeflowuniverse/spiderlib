module uikitweb

import vweb
import freeflowuniverse.spiderlib.uikit { Navbar, Shell, Sidebar }
import freeflowuniverse.spiderlib.htmx { HTMX }
import freeflowuniverse.spiderlib.uikit.tailwindui { TailwindUI }
// import freeflowuniverse.spiderlib.uikit2.tailwindui.sidebar {LightSidebar, Link}

struct App {
	vweb.Context
	vweb.Controller
}

pub fn (mut app App) index() vweb.Result {
	navbar := Navbar{
		navitems: [
			uikit.NavItem{
				label: 'Home'
				htmx: HTMX{
					get: '/home'
					target: 'main'
				}
			},
			uikit.NavItem{
				label: 'Tailwindui'
				htmx: HTMX{
					get: '/tailwindui'
					target: 'main'
				}
			},
		]
	}

	sidebar := Sidebar{
		navitems: [
			uikit.NavItem{
				label: 'Home'
				url: '/'
			},
			uikit.NavItem{
				label: 'Tailwindui'
				htmx: HTMX{
					get: '/tailwindui'
					target: 'main'
				}
			},
		]
	}

	footer := uikit.Footer{}
	shell := Shell{
		navbar: navbar
		sidebar: sidebar
		footer: footer
		homepage: '/home'
	}

	index := uikit.Index{
		scripts: ['/static/js/htmx.min.js']
		stylesheets: ['/static/css/index.css']
		shell: shell
	}

	return $vweb.html()
}

pub fn (mut app App) home() vweb.Result {
	page := uikit.Page{
		title: 'Home Page'
		description: 'Sample home page'
	}
	return $vweb.html()
}

pub fn main() {
	mut app := &App{
		controllers: [
			vweb.controller('/tailwindui', &TailwindUI{}),
		]
	}
	app.mount_static_folder_at('static', '/static')
	vweb.run[App](app, 8080)
}
