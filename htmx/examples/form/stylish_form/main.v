module main

import freeflowuniverse.spiderlib.htmx
import net.http
import os
import freeflowuniverse.spiderlib.uikit.flowbite
import vweb

pub struct App {
	vweb.Context
}

pub fn main () {
	dir := os.dir(@FILE)
	
	os.chdir(dir)!
	os.execute('tailwindcss -i ${dir}/index.css -o ${dir}/static/index.css --minify')
	
	mut app := App{}
	app.mount_static_folder_at('${dir}/static', '/static')
	vweb.run[App](&app, 8082)
}

pub fn (mut app App) index() vweb.Result {
	input := flowbite.BasicInput {
		name: 'example'
		label: 'Example input'
	}
	another_input := flowbite.BasicInput {
		name: 'another'
		label: 'Another input'
	}

	form_htmx := htmx.HTMX {
		post:'/submit'
		target: 'form'
		swap: 'outerHTML'
	}

	submit_btn := flowbite.DefaultButton{
		label: 'Submit'
		htmx: form_htmx
	}

	form := flowbite.DefaultForm {
		htmx: form_htmx
		inputs: [input, another_input]
		button: submit_btn
	}

	return app.html($tmpl('index.html'))
}

[POST]
pub fn (mut app App) submit() vweb.Result {
	data := http.parse_form(app.req.data)
	input_data := data['example']
	another_data := data['another']
	return app.html('<p style="color: white"> Example input: ${input_data}</p><br><p style="color: white">Another input: ${another_data}</p>')
}