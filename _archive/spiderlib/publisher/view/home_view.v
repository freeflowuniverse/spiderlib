module view

import vweb
import os
import freeflowuniverse.spiderlib.uikit.pages { BlankPage }
import freeflowuniverse.crystallib.markdowndocs

struct Home {
	name string
}

pub fn (mut app App) home() vweb.Result {
	mut mdparser := markdowndocs.get('content/home/home.md') or { panic('cannot parse,${err}') }

	blank := BlankPage{
		content: mdparser.doc.html()
	}

	return app.html(blank.html())
}
