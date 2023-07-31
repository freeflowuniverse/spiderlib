module flowbite

pub struct Navbar {
pub:
	logo string
	// search_htmx   htmx.HTMX
	notifications DropdownButton
	nav           []Button
}

pub fn (navbar Navbar) str() string {
	return $tmpl('./templates/navbar.html')
}

pub struct Sidebar {
pub:
	nav []NavButton
}

pub fn (sidebar Sidebar) str() string {
	return $tmpl('./templates/sidebar.html')
}
