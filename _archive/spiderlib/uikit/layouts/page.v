module layouts

pub struct Page {
	pub:
	title string
	meta map[string]string
	content string
}


	// mut mdparser := markdowndocs.get('content/home/home.md') or { panic('cannot parse,$err') }

	// blank := BlankPage{
	// 	content: mdparser.doc.html()
	// }

	// return app.html(blank.html())