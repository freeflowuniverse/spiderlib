module partials

pub struct Card {
	pub:
	title       string
	subtitle    string
	description string
	template    string = './components/card.html'
}

pub fn (card Card) html() string {
	return $tmpl('./templates/card.html')
	// return '<main>$blank.content</main>'
}