module uikit

import freeflowuniverse.spiderlib.htmx

pub interface IForm {
	IComponent
	htmx   htmx.HTMX
	inputs []IInput
	button IButton
}

pub struct Form {
	Component
pub:
	htmx   htmx.HTMX
	inputs []IInput
	button IButton
}

pub fn (form Form) html() string {
	return $tmpl('./templates/form.html')
}
