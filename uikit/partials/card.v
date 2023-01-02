module partials

import freeflowuniverse.spiderlib.html
import freeflowuniverse.spiderlib.uikit.elements

pub struct Card {
	html.HTML
	pub:
	title       string
	subtitle    string
	description string
	footer []elements.Button
	template    string = './components/card.html'
}

pub fn (card Card) html() string {
	return $tmpl('./templates/card.html')
	// return '<main>$blank.content</main>'
}