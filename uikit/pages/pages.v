module pages

import freeflowuniverse.spiderlib.uikit.partials { Card }
type Main = BlankPage

pub struct BlankPage {
pub:
	content string
}

pub fn (blank BlankPage) html() string {
	return $tmpl('templates/blank.html')
	// return '<main>$blank.content</main>'
}

// displays a series of cards 
pub struct Cards {
	pub:
	content []Card	
}

pub fn (cards Cards) html() string {
	return $tmpl('templates/cards.html')
	// return '<main>$blank.content</main>'
}