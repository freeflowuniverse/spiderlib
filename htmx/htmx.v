module htmx

import freeflowuniverse.crystallib.pathlib { Path }

type Pathbool = Path | bool

pub struct HTMX {
	boost      ?bool
	get        ?string
	post       ?string
	put        ?string
	delete     ?string
	push_url   ?string
	select_oob ?string
	swap       ?string
	swap_oob   ?string
	target     ?string
	trigger    ?string
	vals       ?string
}

pub fn (hx HTMX) str() string {
	mut attributes := []string{}
	$for field in HTMX.fields {
		val := hx.$(field.name)
		if field.is_option && val != none {
			// hack around to unwrap optional
			val_str := '${val}'.all_after('Option').trim('\'()')
			attributes << "hx-${field.name.replace('_', '-')}=${val_str}"
		}
	}
	return attributes.join(' ')
}

