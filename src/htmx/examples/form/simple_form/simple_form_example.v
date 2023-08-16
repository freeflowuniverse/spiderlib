module main

import freeflowuniverse.spiderlib.htmx
import net.http
import os
import freeflowuniverse.spiderlib.uikit
import vweb

pub struct App {
	vweb.Context
}

pub fn main() {
	dir := os.dir(@FILE)
	mut app := App{}
	app.mount_static_folder_at('${dir}/static', '/static') //TODO: use factory for all the components we re-use
	vweb.run[App](&app, 8082)
}

pub fn (mut app App) index() vweb.Result {
	input := uikit.Input{
		name: 'example'
		label: 'Example input'
	}

	submit_btn := uikit.Button{
		label: 'Submit'
	}

	form_htmx := htmx.HTMX{
		post: '/submit'
		target: 'this'
	}

	form := uikit.Form{
		htmx: form_htmx
		inputs: [input]
		button: submit_btn
	}

	return app.html($tmpl('index.html'))
}

[POST]
pub fn (mut app App) submit() vweb.Result {
	data := http.parse_form(app.req.data)
	input_data := data['example']
	return app.html('Submitted data: ${input_data}')
}
