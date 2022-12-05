module htmx

import freeflowuniverse.crystallib.pathlib { Path }

type Pathbool = Path | bool

pub struct HTMX {
	boost      bool
	get        string
	post       string
	put        string
	delete     string
	push_url   string
	select_oob string
	swap       string
	swap_oob   string
	target     string
	trigger    string
	vals       string
}

pub fn (hx HTMX) stringify() string {
	obj_str := hx.str().trim_right('\n}')
	attributes := obj_str.split('\n')
	mut repr := ''
	for line in attributes[1..].filter(it.split(': ')[1] != "''") {
		key := line.split(': ')[0].trim_left(' ')
		val := line.split(': ')[1]
		repr += 'hx-${key.replace('_', '-')}=$val '
	}
	return repr
}
