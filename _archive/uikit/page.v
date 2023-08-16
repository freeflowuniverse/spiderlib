module uikit

pub struct Page {
pub:
	heading     ?PageHeading
	title       string
	description string
}

pub struct PageHeading {
pub:
	title       string
	description string
}
