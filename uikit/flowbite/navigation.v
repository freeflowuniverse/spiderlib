module flowbite

pub struct Navbar {
pub:
	logo string
	// search_htmx   htmx.HTMX
	notifications DropdownButton
	nav           []IButton
}

pub fn (navbar Navbar) html() string {
	return $tmpl('./templates/navbar.html')
}

pub struct Sidebar {
pub:
	nav []NavButton
}

pub fn (sidebar Sidebar) html() string {
	return $tmpl('./templates/sidebar.html')
}
