module main

import freeflowuniverse.spiderlib.htmx
import net.http
import os
import freeflowuniverse.spiderlib.uikit.flowbite
import vweb

pub fn (mut app App) index() vweb.Result {
	input := flowbite.BasicInput{
		name: 'name'
		label: 'Name'
	}
	another_input := flowbite.BasicInput{
		name: 'age'
		label: 'Age'
	}

	form_htmx := htmx.HTMX{
		post: '/submit'
		target: '#table' //see below, is A
		swap: 'beforeend'
	}

	submit_btn := flowbite.DefaultButton{
		label: 'Submit'
		htmx: form_htmx
	}

	form := flowbite.DefaultForm{
		htmx: form_htmx
		inputs: [input, another_input]
		button: submit_btn
	}

	table := flowbite.DefaultTable{
		id: 'table' //css selector as chosen see A above
		headers: ['Name', 'Age']
		rows: app.get_rows()
	}

	return app.html($tmpl('index.html'))
}

[POST]
pub fn (mut app App) submit() vweb.Result {
	row := app.add_row(app.req.data)
	return app.html(row.html())
}
