module main

import vweb
import freeflowuniverse.spiderlib.htmx
import os
import net.http


struct App {
	vweb.Context
}

pub fn (mut app App) index() vweb.Result {
	form_htmx := htmx.form(post_path: '/form_post')
	return $vweb.html()
}

struct Form {
	email string
}

[POST]
pub fn (mut app App) form_post() vweb.Result {
	parsed := http.parse_form(app.req.data)
	return app.html('<p>Your email is ${parsed['email']}</p>')
}

pub fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') { os.mkdir('${dir}/static')! }
	os.chdir('${dir}/static')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')
	mut app := App{}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run[App](&app, 8080)
}
