module ui_kit

import freeflowuniverse.crystallib.pathlib { Path }
import freeflowuniverse.spiderlib.htmx { HTMX }
import net.urllib { URL }

// source is source of an image something
type Source = Path | URL

struct Element {
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
	return $tmpl('templates/elements/button.html')
}

struct SVG {

}

struct Img {
	src string
	alt string
}

struct Anchor {
	label string
	href string
}

struct Heading {

}

struct Paragraph {

}

struct Form {
	action Action
}

struct Input {

}

struct Details {

}

struct Table {

}

struct Div {

}

struct Span {

}