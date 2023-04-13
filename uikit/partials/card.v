module partials

import freeflowuniverse.spiderlib.html
import freeflowuniverse.spiderlib.uikit.elements

pub struct Card {
	html.Div
	pub:
	title       string
	subtitle    string
	description string
}

pub struct Card2 {
	html.Div
	pub:
	title       string
	subtitle    string
	description string
}

pub interface ICard {
	html.IElement
	title       string
	subtitle    string
	description string
}

pub type CardTyp = Card | Card2

pub fn (card Card) html() string {
	return $tmpl('./templates/card.html')
	// return '<main>$blank.content</main>'
}


// // Flowbite Dashboard Card
// pub struct FBDashboardCard {
// 	Card
// 	pub:
// 	heading string
// 	description string
// 	button html.Button
// 	delta f64
// 	content FBCardContent = EmptyContent{}
// }

// sum type for possible card contents
// pub type FBCardContent = FBList | EmptyContent | FBTable