module uikit

import freeflowuniverse.spiderlib.htmx

// All UIKit components must implement a string method that outputs their html code.
pub interface IComponent {
	html() string
}

pub struct Component {
pub:
	htmx htmx.HTMX
}
