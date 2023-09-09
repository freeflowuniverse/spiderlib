module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

[params]
pub struct LoginPageParams {
	route string
}

// pub fn login_page(params LoginPageParams) FormPage {
// 	return FormPage{
// 		title: 'Sign In'
// 		form: SignInForm{
// 			action: htmx.form(post_path: params.route)
// 			inputs: [
// 				InputWithLabel{},
// 			]
// 		}
// 		// button:
// 	}
// }

pub struct Profile {
pub:
	name         string
	title        string
	location     string
	email        string
	address      string
	phone        string
	bio          string
	education    string
	date_joined  string
	organization string
	department   string
}

pub struct ProfilePage {
pub:
	profile Profile
}

[params]
pub struct EditProfilePageParams {
pub:
	title             string
	profile           Profile
	post_general_info string
	post_date_time    string
}

pub fn edit_profile_page(params EditProfilePageParams) SettingsPage {
	return SettingsPage{
		title: params.title
		profile: params.profile
		left_forms: [
			DefaultForm{},
			DefaultForm{},
		]
		right_forms: [
			DefaultForm{
				htmx: htmx.HTMX{
					post: params.post_general_info
				}
			},
			DefaultForm{},
		]
	}
}

[params]
pub struct RegistrationPage {
	RegistrationFormConfig
pub:
	title string
	// post_general_info string
	// post_date_time string
}

pub fn registration_page(page RegistrationPage) FormPage {
	return FormPage{
		title: page.title
		form: registration_form(page.RegistrationFormConfig)
	}
}

[params]
pub struct LoginPage {
	RegistrationFormConfig
pub:
	form  Form
	title string
	// post_general_info string
	// post_date_time string
}

pub fn login_page(page LoginPage) FormPage {
	return FormPage{
		title: page.title
		form: registration_form(page.RegistrationFormConfig)
	}
}
