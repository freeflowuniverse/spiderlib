module main

import vweb

pub fn (mut app App) @{page.name}() vweb.Result {
	page := @{page.template}
	return @{dollar}vweb.html()
}