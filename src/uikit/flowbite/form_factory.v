module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

pub struct RegistrationFormConfig {
	inputs       []uikit.IInput
	submit_route string
	login_route  string
}

// pub struct RegistrationField {
// 	typ RegistrationFieldType
// 	required
// }

// pub enum RegistrationFieldType {
// 	.name
// 	.email
// 	.phone
// 	.remember_me
// 	.terms_and_conditions
// }

pub fn registration_form(config RegistrationFormConfig) RegistrationForm {
	login_htmx := htmx.HTMX{
		get: config.login_route
		swap: 'outerHTML'
	}
	login_text := 'Already have an account? <a ${login_htmx} class="text-primary-700 hover:underline dark:text-primary-500 cursor-pointer">Login here</a>'
	return RegistrationForm{
		id: 'registration-form'
		inputs: config.inputs
		htmx: htmx.HTMX{
			post: config.submit_route
			swap: 'outerHTML'
		}
		button: DefaultButton{
			htmx: htmx.HTMX{
				post: config.submit_route
				target: '#registration-form'
				swap: 'outerHTML'
			}
			label: 'Register'
		}
		login_text: login_text
	}
}
