module flowbite

import freeflowuniverse.spiderlib.htmx

pub struct LoginPage {
pub:
	form  Form
	title string
}

pub fn (page LoginPage) html() string {
	return $tmpl('templates/pages/sign-in.html')
}

pub struct NotFoundPage {
pub:
	title   string
	content string
	button  string
	link    string
}

pub fn (page NotFoundPage) html() string {
	return $tmpl('templates/pages/not-found.html')
}

pub struct ForgotPassword {
pub:
	form    Form
	title   string
	content string
}

pub fn (page ForgotPassword) html() string {
	return $tmpl('templates/pages/forgot-password.html')
}

pub struct ProfileLock {
pub:
	form    Form
	title   string
	content string
}

pub fn (page ProfileLock) str() string {
	return $tmpl('templates/pages/profile-lock.html')
}

pub struct ResetPassword {
pub:
	form  Form
	title string
}

pub fn (page ResetPassword) str() string {
	return $tmpl('templates/pages/reset-password.html')
}

pub struct SignUp {
pub:
	form  Form
	title string
}

pub interface IForm {
	html() string
}

pub fn (page SignUp) html() string {
	return $tmpl('templates/pages/sign-up.html')
}

pub struct MailboxPage {
pub:
	title  string
	emails []Email
}

pub fn (page MailboxPage) html() string {
	return $tmpl('templates/pages/mailbox.html')
}

pub struct ComposePage {
	title string
}

pub fn (page ComposePage) html() string {
	return $tmpl('templates/pages/compose.html')
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

pub fn (page EmailPage) html() string {
	return $tmpl('templates/pages/email.html')
}

pub struct FormPage {
pub:
	form  IForm
	title string
}

pub fn (page FormPage) html() string {
	return $tmpl('templates/pages/form-page.html')
}

[params]
pub struct LoginPageParams {
	route string
}

pub fn login_page(params LoginPageParams) FormPage {
	return FormPage{
		title: 'Sign In'
		form: SignInForm{
			action: htmx.form(post_path: params.route)
			inputs: [
				InputWithLabel{},
			]
		}
		// button:
	}
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

pub fn (page UsersPage) html() string {
	return $tmpl('templates/pages/users.html')
}
