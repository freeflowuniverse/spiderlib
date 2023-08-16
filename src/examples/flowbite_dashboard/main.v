import vweb
import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.uikit.flowbite
import os
// import freeflowuniverse.spiderlib.uikit2.tailwindui.sidebar {LightSidebar, Link}

struct App {
	vweb.Context
	vweb.Controller
}

pub fn main() {
	dir := os.dir(@FILE)
	os.chdir(dir)!
	os.execute('tailwindcss -i ${dir}/index.css -o ${dir}/static/css/index.css --minify')
	mut app := &App{
		controllers: []
	}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run[App](app, 8080)
}
