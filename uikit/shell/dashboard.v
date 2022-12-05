module shell

import vweb
import freeflowuniverse.spiderlib.uikit.partials

struct App {
	vweb.Context
}

pub struct Dashboard {
pub mut:
	logo_path string
	navbar partials.Navbar
	sidebar partials.Sidebar
	footer string
	default_content string
	template string = "./dashboard.html"
	router string
	output string
}

pub fn (dashboard Dashboard) render() string {
	current_url:= '/home'
	return $tmpl('templates/dashboard.html')
}
