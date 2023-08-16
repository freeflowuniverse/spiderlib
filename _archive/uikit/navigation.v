module uikit

import freeflowuniverse.spiderlib.htmx

pub struct Navbar {
	Nav
}

pub struct Sidebar {
	Nav
}

pub struct Footer {
	Nav
}

pub struct Nav {
pub:
	navitems []NavItem
}

pub struct NavItem {
pub:
	url    string
	label  string
	target string
	htmx   htmx.HTMX
}
