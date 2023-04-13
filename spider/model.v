module spider

import time

struct Web {
	name string
	path string
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