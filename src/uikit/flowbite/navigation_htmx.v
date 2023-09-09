module flowbite

pub fn (navbar Navbar) html() string {
	return $tmpl('./templates/navigation/navbar.html')
}

pub fn (sidebar Sidebar) html() string {
	return $tmpl('./templates/sidebar.html')
}
