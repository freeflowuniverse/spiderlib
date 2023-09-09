module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

type Form = SignInForm

pub struct DefaultForm {
	uikit.Form
}

pub struct SignInForm {
	uikit.Form
pub:
	inputs []uikit.IInput
	action htmx.HTMX
}

pub struct RegistrationForm {
	uikit.Form
pub:
	login_text string // text shown below register button to redirect user to login if they have account
}