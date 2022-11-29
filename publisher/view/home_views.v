module view

import vweb
import os
import freeflowuniverse.spiderlib.ui_kit.content { Blank }
import freeflowuniverse.crystallib.markdowndocs

struct Home {
	name string
}

pub fn (mut app App) home() vweb.Result {

	mut mdparser := markdowndocs.get('src/content/home/home.md') or { panic('cannot parse,$err') }

	blank := Blank {
		content: mdparser.doc.html()
	}

	return app.html(blank.html())
}
