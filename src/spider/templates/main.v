module main

import freeflowuniverse.spiderlib.spider
import vweb

struct App {
	vweb.Context
	@if web.controllers.len > 0
	vweb.Controller
	@end
	@for client in web.clients
		client: @client [vweb_global]
	@end
}

pub fn (mut app App) index() vweb.Result {
	return @{dollar}vweb.html()
}

pub fn main() {
	web := spider.load('.')
	web.install()
	web.precompile()

	@for ctrl in web.controllers
	mut controller := @{ctrl}
	@end

	@for client in web.clients
		client := @{client}
	@end

	app := App{
		@for client in web.clients
			client: client
		@end

		@if web.controllers.len > 0
		controllers: [
			@for ctrl in web.controllers
				vweb.controller['controller', controller]
			@end
		]
		@end
		controllers: [
			vweb.controller('/email_controller', &controller),
		]


	}
	vweb.run[App](app, 8080)
}