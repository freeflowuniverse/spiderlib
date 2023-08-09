module flowbite

pub struct LoginPage {
pub:
	form Form
	title	string
}

pub fn (page LoginPage) str() string {
	return $tmpl('templates/pages/sign-in.html')
}

pub struct NotFoundPage {
pub:
	title   string
	content string
	button  string
	link    string
}

pub fn (page NotFoundPage) str() string {
	return $tmpl('templates/pages/not-found.html')
}

pub struct ForgotPassword {
pub:
	form 	Form
	title   string
	content string
}

pub fn (page ForgotPassword) str() string {
	return $tmpl('templates/pages/forgot-password.html')
}

pub struct ProfileLock {
pub:
	form 	Form
	title   string
	content string
}

pub fn (page ProfileLock) str() string {
	return $tmpl('templates/pages/profile-lock.html')
}

pub struct ResetPassword {
pub:
	form 	Form
	title   string
}

pub fn (page ResetPassword) str() string {
	return $tmpl('templates/pages/reset-password.html')
}

pub struct SignUp {
pub:
	form 	Form
	title   string
}

pub fn (page SignUp) str() string {
	return $tmpl('templates/pages/sign-up.html')
}