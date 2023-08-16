module uikit

import freeflowuniverse.spiderlib.htmx

pub interface IButton {
	IComponent
	label string
	htmx htmx.HTMX
}

pub struct Button {
pub:
	label string
	htmx  htmx.HTMX
}

pub fn (button Button) html() string {
	return $tmpl('./templates/button.html')
}
