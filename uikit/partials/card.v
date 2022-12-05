module partials

import freeflowuniverse.spiderlib.uikit.elements

pub struct Card {
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