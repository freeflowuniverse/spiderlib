module flowbite

type Button = AppButton | DropdownButton | NavButton

pub struct AppButton {
pub:
	label   string
	tooltip string
	route   string
	logo    string
}

pub struct DropdownButton {
pub:
	title    string
	tooltip  string
	logo     string
	dropdown Dropdown
}

pub struct NavButton {
pub:
	logo  string
	label string
	route string
}

pub fn (mut button NavButton) str() string {
	return $tmpl('templates/button/nav-button.html')
}
