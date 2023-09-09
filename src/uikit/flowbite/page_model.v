module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

// pub struct LoginPage {
// pub:
// 	form  Form
// 	title string
// }

pub struct NotFoundPage {
pub:
	title   string
	content string
	button  string
	link    string
}

pub struct ForgotPassword {
pub:
	form    Form
	title   string
	content string
}

pub struct ProfileLock {
pub:
	form    Form
	title   string
	content string
}

pub struct ResetPassword {
pub:
	form  Form
	title string
}

pub struct SignUp {
pub:
	form  IForm
	title string
}

pub interface IForm {
	// uikit.IForm	
	htmx htmx.HTMX
	html() string
}

pub struct MailboxPage {
pub:
	title  string
	emails []Email
}

pub struct ComposePage {
	title string
}

pub struct EmailPage {
	title string
	email Email
}

pub struct Email {
pub:
	to      string
	from    string
	subject string
	body    string
}

pub struct FormPage {
pub:
	form  IForm
	title string
}

pub struct User {
pub:
	name     string
	email    string
	position string
	country  string
}

[params]
pub struct UsersPage {
pub:
	users      []User
	add_button struct {
	pub:
		htmx  htmx.HTMX
		label string
	}
}

pub struct TablePage {
pub:
	table ITable [required]
}

pub struct SettingsPage {
pub:
	title       string
	profile     Profile
	left_forms  []IForm
	right_forms []IForm
}
