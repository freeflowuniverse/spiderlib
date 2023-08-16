module main

import freeflowuniverse.spiderlib.spider
import vweb

struct App {
	vweb.Context
}

pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub fn main() {
	app := App{}
	vweb.run[App](app, 8080)
}
