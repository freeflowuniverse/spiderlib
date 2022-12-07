module view

import vweb
import time { Time }
import os
import freeflowuniverse.spiderlib.uikit.shell { Dashboard }
import freeflowuniverse.crystallib.publisher2 { Publisher, User }
import freeflowuniverse.crystallib.pathlib

const (
	port = 8001
)

pub fn (mut app App) before_request() {
	hx_request := app.get_header('Hx-Request') == 'true'
	if !hx_request && app.req.url != '/' && app.req.url.ends_with('.html') && !app.req.url.starts_with('/sites/') {
		app.redirect('')
	}
	// updates app user before each request
	token := app.get_cookie('token') or { '' }
	app.user = get_user(token) or { User{} }
}

fn new_app() &App {
	mut app := &App{}
	app.mount_static_folder_at(os.resource_abs_path('view/static'), '/static')
	return app
}

struct App {
	vweb.Context
mut:
	user           User
	email          string
	attempted_url  string
	dashboard      Dashboard
	authenticators shared map[string]Auth
	home           Home
}

struct AccessGroup {
	name string
}

struct Auth {
	max_attempts int = 3
mut:
	timeout       Time
	auth_code     []u8
	attempts      int  = 0
	authenticated bool = false
}

pub fn run_view() {
	mut app := new_app()
	vweb.run(app, port)
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
