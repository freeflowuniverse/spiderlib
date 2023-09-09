module flowbite

pub struct Navbar {
pub:
	logo string
	title string
	// search_htmx   htmx.HTMX
	notifications DropdownButton
	nav           []IButton
}

pub struct Sidebar {
pub:
	nav []NavButton
}
