module tailwindui

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

pub struct SimpleDarkWithMenuButtonOnLeft {
	Navbar
}

pub fn (navbar SimpleDarkWithMenuButtonOnLeft) str() string {
	return $tmpl('./templates/navbar/simple_dark_with_menu_button_on_left.html')
}