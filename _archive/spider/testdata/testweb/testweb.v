module main

import freeflowuniverse.spiderlib.spider
import vweb

struct Web {
	vweb.Context
	spider.Web
}

pub fn (mut web Web) index() vweb.Result {
	return $vweb.html()
}

pub fn main() {
	do() or {panic(err)}
}

fn do() ! {
	web := spider.load(path:'.')
	web.update()!

	testweb := Web{
		Web: web
	}

	vweb.run[Web](testweb, 8080)
}
