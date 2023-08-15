module main

import os
import vweb

pub fn main () {
	dir := os.dir(@FILE)
	
	os.chdir(dir)!
	os.execute('tailwindcss -i ${dir}/index.css -o ${dir}/static/index.css --minify')
	
	mut app := App{}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run[App](&app, 8082)
}