module ui_kit

import vweb
import freeflowuniverse.spiderlib.htmx

pub type MenuItem = Dropdown | Action 
pub type Menu = []MenuItem 

pub struct Sidebar {
	pub:
	menu   []Button
	bottom_menu Menu
}

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