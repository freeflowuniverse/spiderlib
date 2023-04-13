module elements

import freeflowuniverse.spiderlib.htmx { HTMX }

// pub type Button = IconButton | RoundedButton | LinkButton

pub struct Button {
	pub:
	hx HTMX
	label string
	icon string
}

pub interface IButton {
	hx HTMX
	label string
	icon string
}

// button with icon
pub struct IconButton {
pub:
	label string
	icon  string
	hx    htmx.HTMX
}

pub fn (button IconButton) html() string {
	return $tmpl('./templates/button.html')
}

pub struct RoundedButton {
pub mut:
	label string
	hx htmx.HTMX
}

pub fn (button RoundedButton) html() string {
	return $tmpl('./templates/rounded_button.html')
}

// Anchor tag that is styled like a button
pub struct LinkButton {
pub mut:
	label string
	src string
	target string
	hx    htmx.HTMX
}

pub fn (button LinkButton) html() string {
	return $tmpl('./templates/link_button.html')
}