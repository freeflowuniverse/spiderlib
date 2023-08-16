module partials

import vweb
import freeflowuniverse.spiderlib.uikit.elements { IButton }

// sidebar
pub interface ISidebar {
	menu []IButton
	bottom_menu []IButton
}

pub struct Sidebar {
pub:
	menu        []IButton
	bottom_menu []IButton
}
