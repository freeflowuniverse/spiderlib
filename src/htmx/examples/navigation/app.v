module main

import vweb
import freeflowuniverse.spiderlib.htmx
import os

struct App {
	vweb.Context
}

pub fn (mut app App) index() vweb.Result {
	home_nav_htmx := htmx.navigate(route: '/home')
	page_nav_htmx := htmx.navigate(route: '/page')
	outlet_htmx := htmx.outlet(default: '/home')
	return $vweb.html()
}

pub fn (mut app App) home() vweb.Result {
	return app.html('<h1>Home</h1>')
}

pub fn (mut app App) page() vweb.Result {
	return app.html('<h1>Page</h1>')
}

pub fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') {
		os.mkdir('${dir}/static')!
	}
	os.chdir('${dir}/static')!
	//TODO: do in factory
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')
	mut app := App{}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run[App](&app, 8080)
}
