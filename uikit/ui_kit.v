module uikit

import freeflowuniverse.crystallib.publisher2 { User }
import freeflowuniverse.crystallib.pathlib
import vweb
import os
import gx { Color }
import freeflowuniverse.spiderlib.uikit.shell

pub interface Component {
	template string // path to html template
}

// pub fn (comp Component) render() string {
// 	template := 'comp.template'
// 	return $tmpl('$comp.template')
// }

// pub struct Router {
// 	main Route
// 	routes []Route
// 	output string
// pub mut:
// 	active Route
// }

// a gatekeeper function for routes
// takes a user, returns whether they have access
type Routekeeper = fn (user User) bool

pub struct Route {
pub:
	route        string
	redirect     string
	access_check Routekeeper
}

// struct Palette {
// 	colors []Color
// }

// pub struct Theme {
// 	palette Palette
// }

// pub struct UserInterface {
// 	shell shell.Shell
// 	pages []Page
// 	theme Theme
// }
