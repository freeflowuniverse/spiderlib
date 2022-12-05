module uikit

import freeflowuniverse.spiderlib.htmx { HTMX }


pub struct Footer {
pub:
	links    []string
	template string = './dashboard.html'
}

pub struct Card {
	pub:
	title       string
	subtitle    string
	description string
	footer      []Component
	template    string = './components/card.html'
}

// type Buttons = Button | Dropdown

pub fn (card Card) render() string {
	return $tmpl('templates/components/card.html')
}