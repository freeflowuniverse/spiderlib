module flowbite

pub struct LoginPage {
pub:
	form Form
}

pub fn (page LoginPage) str() string {
	return $tmpl('templates/pages/sign-in.html')
}
