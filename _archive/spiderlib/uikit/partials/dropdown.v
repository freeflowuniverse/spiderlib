module partials

import freeflowuniverse.spiderlib.uikit.elements

pub struct Dropdown {
	label    string
	icon     string
	options  []elements.Button
	template string = './components/dropdown.html'
}
