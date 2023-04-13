module flowbite

import freeflowuniverse.spiderlib.html

pub struct DashboardCard {
	html.Div
	pub:
	heading string
	description string
	button html.Button
	delta f64
	content CardContent = EmptyContent{}
}

pub fn (card DashboardCard) render_content() string {
	// match card.content
	// CardList {
	// 	return $tmpl('templates/card_list.html')
	// }
	// Table {
	// 	table := card.content as Table
	// 	return $tmpl('templates/table.html')
	// }
	// else{}
	return ''
	// return '<main>$blank.content</main>'
}

// sum type for possible card contents
pub type CardContent = CardList | EmptyContent | Table

// default content for card
pub struct EmptyContent{}

pub struct CardList {
	pub:
	list []ListItem
}

pub struct ListItem {
	pub:
	logo string
	heading string
	time string
	tag string
	content string
}

pub struct Table {
pub:
	headers []string
	rows [][]string
}
// pub fn (card Card)

