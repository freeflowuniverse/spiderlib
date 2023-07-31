module uikit

import freeflowuniverse.spiderlib.htmx

// All UIKit components must implement a string method that outputs their html code.
pub interface IComponent {
	str() string
}

// the index of the file
// holds metadata and scripts to be imported
// and application shell
pub struct Index {
pub:
	scripts     []string
	stylesheets []string
	shell       IShell
}

//
pub interface IShell {
}

pub struct Shell {
pub:
	page    Page
	navbar  INavbar
	content IComponent
	sidebar ISidebar
	footer  IFooter
}

pub interface INavbar {
	str() string
}

pub struct Navbar {
pub:
	nav []IButton
}

pub interface IButton {
	label string
	action string
}

pub interface ISidebar {
	str() string
}

pub struct Sidebar {
pub:
	menu []IMenuItem
}

pub interface IFooter {
	str() string
}

pub struct Footer {
pub:
	menu []IMenuItem
}

pub struct Menu {
pub:
	items []MenuItem
}

pub interface IMenuItem {
	label string
	route string
}

pub fn (i IMenuItem) htmx() string {
	hx := htmx.navigate(route: '${i.route}')
	return hx.str()
}

pub struct MenuItem {
pub:
	label string
	route string
}

pub struct Page {
pub:
	title       string
	description string
	route       string
	content     string
}

pub fn (page Page) str() string {
	return ''
}

pub struct Card {
pub:
	title   string
	content string
}
