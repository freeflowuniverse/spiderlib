module flowbite

import freeflowuniverse.spiderlib.htmx

type Form = SignInForm

pub interface IInput {
	html() string
}

pub struct SignInForm {
pub:
	inputs []IInput
	action htmx.HTMX
}

pub fn (form SignInForm) html() string {
	return $tmpl('templates/form/sign-in-form.html')
}
