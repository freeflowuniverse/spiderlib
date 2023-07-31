module main

import vweb
import freeflowuniverse.spiderlib.uikit.flowbite

pub fn (mut app App) login() vweb.Result {
	login_page := flowbite.LoginPage{}
	return app.html('${login_page}')
}
