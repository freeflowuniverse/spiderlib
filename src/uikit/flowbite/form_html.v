module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit


pub fn (form DefaultForm) html() string {
	return $tmpl('templates/form/default-form.html')
}

pub fn (form RegistrationForm) html() string {
	return $tmpl('templates/form/registration-form.html')
}

pub fn (form SignInForm) html() string {
	return $tmpl('templates/form/sign-in-form.html')
}
