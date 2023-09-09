module flowbite

import freeflowuniverse.spiderlib.uikit
// import freeflowuniverse.spiderlib.htmx

pub struct Shell {
pub:
	navbar  Navbar
	sidebar Sidebar
	footer  Footer
	// page Page
	router map[string]string
pub mut:
	route string
}

pub fn (shell Shell) html() string {
	return $tmpl('./templates/shell.html')
}

pub struct NavItem {
	uikit.MenuItem
pub:
	icon string
}

pub struct Footer {
	uikit.Footer
}

pub fn (sidebar Footer) html() string {
	return $tmpl('./templates/footer.html')
}

pub struct Content {
	uikit.Content
}

pub fn (content Content) str() string {
	return $tmpl('./templates/content.html')
}
