module view

import vweb
import time
import os
import freeflowuniverse.spiderlib.uikit.shell { Dashboard }
import freeflowuniverse.spiderlib.auth.jwt
import freeflowuniverse.crystallib.publisher2
import freeflowuniverse.crystallib.pathlib

const (
	port = 8001
)

struct App {
	vweb.Context
mut:
	username      string
	email         string
	attempted_url string
	dashboard     Dashboard
}

pub fn (mut app App) before_request() {
	// redirects to requests to index
	hx_request := app.get_header('Hx-Request') == 'true'
	if !hx_request && app.req.url != '/' && app.req.url.ends_with('.html')
		&& !app.req.url.starts_with('/sites/') {
		app.redirect('')
	}

	// updates app username before each request
	token := app.get_cookie('token') or { '' }
	app.username = jwt.get_data(token) or { '' }
}

// creates, initializes and returns app
fn new_app() &App {
	mut app := &App{}
	app.mount_static_folder_at(os.resource_abs_path('view/static'), '/static')
	return app
}

pub fn run_view() {
	mut app := new_app()
	vweb.run(app, view.port)
}

pub fn (mut app App) index() vweb.Result {
	mut route := 'dashboard'
	if app.get_header('Hx-Request') != 'true' {
		if app.req.url != '/' {
			route = app.req.url.all_after_first('/')
		}
	}
	return $vweb.html()
}
