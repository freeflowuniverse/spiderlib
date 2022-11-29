module content

import freeflowuniverse.spiderlib.ui_kit.partials { Card }
type Main = Blank

pub struct Blank {
pub:
	content string
}

pub fn (blank Blank) html() string {
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