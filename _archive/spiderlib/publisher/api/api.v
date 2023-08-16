module api

import vweb
import time
import os
import uikit.shell
import freeflowuniverse.spiderlib.publisher.publisher
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.spiderlib.auth.jwt

const (
	port = 8001
)

pub fn (mut app App) before_request() {
	$if debug {
		eprintln('Incoming request to api: ${app.req}')
	}
	token := app.get_header('Authorization').trim_string_left('Bearer ')

	// sets user from token
	if jwt.verify_jwt(token) {
		app.username = jwt.get_data(token) or { panic(err) }
	}

	println(app)
}

pub fn new_app() &App {
	mut app := &App{
		channel: chan &FunctionCall{cap: 100}
		response_channel: chan &FunctionResponse{cap: 100}
	}
	app.mount_static_folder_at(os.resource_abs_path('./static'), '/static')
	return app
}

pub struct App {
	vweb.Context
pub mut:
	username         string // user identifier
	channel          chan &FunctionCall     [vweb_global]
	response_channel chan &FunctionResponse [vweb_global]
}

pub fn run_api() {
	mut app := new_app()
	vweb.run(app, api.port)
}

pub fn run(app App) {
	vweb.run(app, api.port)
}
