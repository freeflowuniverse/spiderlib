module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

type Form = SignInForm

pub struct DefaultForm {
	uikit.Form
}

pub fn (form DefaultForm) html() string {
	return $tmpl('templates/form/default-form.html')
}

pub struct SignInForm {
pub:
	inputs []uikit.IInput
	action htmx.HTMX
}

pub fn (form SignInForm) html() string {
	return $tmpl('templates/form/sign-in-form.html')
}
