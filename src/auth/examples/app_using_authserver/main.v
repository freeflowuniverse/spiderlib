module main

import freeflowuniverse.spiderlib.auth
import os
import vweb
import net.smtp
import net.http
import toml
import json

// Example vweb application with Email Authenticator
struct App {
	vweb.Context
	vweb.Controller
}

// home page, nothing but an email form that posts input to /login
pub fn (mut app App) index() vweb.Result {
	verify_path := 'verify_email'
	return $vweb.html()
}

fn main() {
	dir := os.dir(@FILE)
	if !os.exists('${dir}/static') {
		os.mkdir('${dir}/static')!
	}
	os.chdir('${dir}/static')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')

	auth_server := auth.new_server()!
	vweb.run(auth_server, 8000)

	// create and run app with authenticator
	mut app := &App{}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run(app, 8080)
}
