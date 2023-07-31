import vweb
import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.uikit.tailwindui
import freeflowuniverse.spiderlib.uikit_web.flowbite_controller
import os
// import freeflowuniverse.spiderlib.uikit2.tailwindui.sidebar {LightSidebar, Link}

struct App {
	vweb.Context
	vweb.Controller
}

pub fn (mut app App) index() vweb.Result {
	// navbar := Navbar{
	// 	navitems: [
	// 		uikit.NavItem,
	// 		{
	// 			label: 'Home'
	// 			htmx:  HTMX{
	// 				get: '/home'
	// 				target: 'main'
	// 			}
	// 		},
	// 		uikit.NavItem,
	// 		{
	// 			label: 'Tailwindui'
	// 			htmx:  HTMX{
	// 				get: '/tailwindui'
	// 				target: 'main'
	// 			}
	// 		},
	// 	]
	// }

	// sidebar := Sidebar{
	// 	navitems: [
	// 		uikit.NavItem,
	// 		{
	// 			label: 'Home'
	// 			url:   '/'
	// 		},
	// 		uikit.NavItem,
	// 		{
	// 			label: 'Tailwindui'
	// 			htmx:  HTMX{
	// 				get: '/tailwindui'
	// 				target: 'main'
	// 			}
	// 		},
	// 	]
	// }

	// footer := uikit.Footer
	// {
	// }
	// shell := Shell{
	// 	navbar: navbar
	// 	sidebar: sidebar
	// 	footer: footer
	// 	homepage: '/home'
	// }

	// index := uikit.Index
	// {
	// 	scripts:
	// 	['/static/js/htmx.min.js']
	// 	stylesheets:
	// 	['/static/css/index.css']
	// 	shell:
	// 	shell
	// }
	return $vweb.html()
}

pub fn main() {
	dir := os.dir(@FILE)
	os.chdir(dir)!
	os.execute('tailwindcss -i ${dir}/index.css -o ${dir}/static/css/index.css --minify')

	mut app := &App{
		controllers: [
			vweb.controller('/tailwindui', &TailwindUI{}),
			vweb.controller('/flowbite', &flowbite_controller.Flowbite{}),
		]
	}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run[App](app, 8080)
}
