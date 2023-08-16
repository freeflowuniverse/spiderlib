module html

import freeflowuniverse.crystallib.pathlib { Path }
import freeflowuniverse.spiderlib.htmx { HTMX }
import net.urllib { URL }

// source is source of an image something
type Source = Path | URL

struct Element {
pub:
	hx      HTMX
	content string
}

// struct Button {
// 	Element
// pub:
// 	content string
// 	icon Source
// 	action HTMX
// }

pub fn (button Button) html() string {
	return '<button></button>'
	// return $tmpl('templates/elements/button.html')
}

struct SVG {
}

struct Img {
	src string
	alt string
}

struct Anchor {
	label string
	href  string
}

struct Heading {
}

pub interface IElement {
	hx HTMX
}

pub struct Button {
	inner string
}

struct Paragraph {
}

// struct Form {
// 	action Action
// }

struct Input {
}

struct Details {
}

struct Table {
}

struct Div {
	Element
}

struct Span {
}
