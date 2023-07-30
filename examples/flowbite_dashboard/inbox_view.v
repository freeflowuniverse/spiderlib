import vweb
import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.uikit.flowbite
import os
// import freeflowuniverse.spiderlib.uikit2.tailwindui.sidebar {LightSidebar, Link}

pub fn (mut app App) inbox() vweb.Result {
	inbox_page := flowbite.InboxPage{}
	return $vweb.html()
}
