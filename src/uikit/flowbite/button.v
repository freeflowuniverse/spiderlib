module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

type Button = AppButton | DropdownButton | NavButton

pub struct DefaultButton {
	uikit.Button
}

pub fn (button DefaultButton) html() string {
	return $tmpl('templates/button/default-button.html')
}

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
	htmx  htmx.HTMX
	id    string
	logo  string
	label string
	route string
}

pub fn (button NavButton) html() string {
	return $tmpl('templates/button/nav-button.html')
}
