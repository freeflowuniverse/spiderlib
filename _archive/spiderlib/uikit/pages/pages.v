module pages

import freeflowuniverse.spiderlib.uikit.partials { Card }
import freeflowuniverse.spiderlib.uikit.elements {Button}

type Main = BlankPage

pub struct Home {
	Page
pub:
	title string
	description string
	background string
	hero_button Button
}

// pub fn (home Home) html() string {
// 	return $tmpl('templates/home.html')
// 	// return '<main>$blank.content</main>'
// }

pub struct PreviewPage {
	Page
	pub:
	title string
	description string
	owner string
	created_at string
}

pub struct BlankPage {
	Page
pub:
	content string
}

// pub fn (blank BlankPage) html() string {
// 	return $tmpl('templates/blank.html')
// 	// return '<main>$blank.content</main>'
// }

// pub fn (page PreviewPage) html() string {
// 	return $tmpl('templates/preview.html')
// 	// return '<main>$blank.content</main>'
// }

// displays a series of cards 
pub struct Cards {
	pub:
	content []Card	
}

// pub fn (cards Cards) html() string {
// 	return $tmpl('templates/cards.html')
// 	// return '<main>$blank.content</main>'
// }