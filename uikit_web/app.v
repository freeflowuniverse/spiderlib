import vweb

import freeflowuniverse.spiderlib.uikit2.tailwindui.sidebar {LightSidebar, Link}

struct App {
	vweb.Context
}

pub fn (mut app App) index() vweb.Result {
	return app.html('hello')
}

pub fn (mut app App) light_sidebar() vweb.Result {
	
	light_sidebar := LightSidebar{
		links: [
			Link {
				label: 'Home'
				icon: ''
			}, Link {
				label: 'About'
				icon: ''
			}
		]
	}

	return app.html(
		'<script src="https://cdn.tailwindcss.com"></script>
		${light_sidebar.html()}'
	)
}

pub fn main() {
	app := App{}
	vweb.run[App](&app, 8080)
}