module layouts

import freeflowuniverse.spiderlib.uikit.partials


pub struct AppShell {
	pub:
	navbar partials.Navbar
	sidebar partials.Sidebar
	pub mut:
	page string
}

pub struct SubShell {
	pub:
	navbar partials.Navbar
	sidebar partials.Sidebar
	pub mut:
	page string
}

