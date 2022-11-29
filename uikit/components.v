module ui_kit

import freeflowuniverse.spiderlib.htmx { HTMX }

pub struct Navbar {
pub mut:
	logo_path string
	username  string
}

pub struct Footer {
pub:
	links    []string
	template string = './dashboard.html'
}

pub struct Button {
pub:
	label string
	icon  string
	hx    HTMX
}

pub struct Dropdown {
	label string
	icon  string
	options []Button
	template    string = './components/dropdown.html'
}

pub struct Card {
	pub:
	title       string
	subtitle    string
	description string
	footer      []Component
	template    string = './components/card.html'
}

type Buttons = Button | Dropdown

pub fn (card Card) render() string {
	return $tmpl('templates/components/card.html')
}