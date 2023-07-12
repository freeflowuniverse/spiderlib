module layouts

import freeflowuniverse.spiderlib.uikit.partials

pub struct CardList {
pub:
	title string
	meta map[string]string
	content string
	cards []partials.ICard
}