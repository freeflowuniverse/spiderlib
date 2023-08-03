module flowbite

pub struct LoginPage {
pub:
	form Form
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
