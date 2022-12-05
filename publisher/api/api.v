module api

import vweb
import time { Time }
import os
import uikit.shell { Dashboard }
import freeflowuniverse.spiderlib.publisher.publisher { Publisher, User }
import freeflowuniverse.spiderlib.api { FunctionCall, FunctionResponse }
import freeflowuniverse.crystallib.pathlib

const (
	port = 8080
)


pub fn (mut app App) before_request() {
	println('ye')
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
	channel chan &FunctionCall [vweb_global]
	response_channel chan &FunctionResponse [vweb_global]
}

// struct Auth {
// 	max_attempts int = 3
// mut:
// 	timeout       Time
// 	auth_code     []u8
// 	attempts      int  = 0
// 	authenticated bool = false
// }

pub fn run_api() {
	mut app := new_app()
	vweb.run(app, port)
}

pub fn run(app App) {
	vweb.run(app, port)
}
