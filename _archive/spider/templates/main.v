module main

import freeflowuniverse.spiderlib.spider
import vweb

struct Web {
	vweb.Context
	spider.Web
}

pub fn (mut web Web) index() vweb.Result {
	return @{dollar}vweb.html()
}

pub fn main() {
	do() or {panic(err)}
}

fn do() ! {
	web := spider.load(path:'.')
	web.update()!

	@web.name := Web{
		Web: web
	}

	vweb.run[Web](@web.name, 8080)
}