module uikit

import freeflowuniverse.spiderlib.htmx

pub struct IForm {
	Component
	htmx   htmx.HTMX
	inputs []IInput
	button IButton
}

pub struct Form {
pub:
	Component
	htmx   htmx.HTMX
	inputs []IInput
	button IButton
}

pub fn (form Form) html() string {
	return $tmpl('./templates/form.html')
}
