module uikit

pub struct Shell {
pub:
	page   Page
	navbar INavbar
}

pub interface INavbar {
	str() string
}

pub struct Navbar {
pub:
	menu Menu
}

pub struct Menu {
pub:
	items []MenuItem
}

pub struct MenuItem {
pub:
	label string
	route string
}

pub struct Page {
pub:
	title       string
	description string
	route       string
	content     string
}

pub fn (page Page) str() string {
	return ''
}

pub struct Card {
pub:
	title   string
	content string
}
