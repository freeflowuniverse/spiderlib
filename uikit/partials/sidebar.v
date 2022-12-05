module partials

import vweb
import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit.elements {Button}

pub type MenuItem = Dropdown | Action 
pub type Menu = []MenuItem 

// pub struct Sidebar {
// 	pub:
// 	menu   []Button
// 	bottom_menu Menu
// }

type Sidebar = DashboardSidebar


// sidebar
pub struct DashboardSidebar {
	pub:
	menu   []Button
	bottom_menu Menu

}

pub fn (sidebar DashboardSidebar) render() string {
	return $tmpl('templates/sidebar.html')
}

// pub struct DashboardSidebar {
// 	pub:
// 	menu   []Page
// }

type HTMX_fn = fn () vweb.Result

pub struct Action {
	pub mut:
	label string
	icon string
	route string
	swap string
	target string
	trigger string = "click"
	action_type ActionType
}

pub enum ActionType {
	htmx
	anchor
}

// pub struct Dropdown {
// 	pub:
// 	label string
// 	icon string
// 	menu []MenuItem 
// }