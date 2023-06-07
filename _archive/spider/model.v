module spider

import freeflowuniverse.crystallib.pathlib
import time

struct Web {
pub:
	name string
	description string
	path pathlib.Path
	pages []Page
	dependencies []IDependency
	created_at time.Time
	updated_at time.Time
}

interface IDependency {
	name string
	installed bool
	load()!
	version()!
	install()!
	update()!
}

struct Page {
	title string
}