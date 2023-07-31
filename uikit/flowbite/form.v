module flowbite

import freeflowuniverse.spiderlib.htmx

type Form = SignInForm

pub struct SignInForm {
pub:
	inputs []Input
	action htmx.HTMX
}

pub fn (form SignInForm) str() string {
	return $tmpl('templates/form/sign-in-form.html')
}
