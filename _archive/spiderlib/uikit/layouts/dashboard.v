module layouts

import vweb
import freeflowuniverse.spiderlib.uikit.partials

struct App {
	vweb.Context
}

pub struct Dashboard {
pub mut:
	logo_path       string
	navbar          partials.DashboardNavbar
	sidebar         partials.DashboardSidebar
	footer          string
	default_content string
	template        string = './dashboard.html'
	router          string
	output          string
}

pub fn (dashboard Dashboard) render() string {
	current_url := '/home'
	return $tmpl('templates/dashboard.html')
}

// pub fn (shell AppShell) html() string {
// 	return $tmpl('templates/shell.html')
// }
