module flowbite

import freeflowuniverse.spiderlib.uikit.partials
import vweb

pub struct AppShell {
pub:
	navbar  partials.INavbar
	sidebar partials.ISidebar
pub mut:
	page string
}
