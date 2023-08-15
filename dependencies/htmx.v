module dependencies

import os

pub struct HTMX {
	version   string
	installed bool
}

fn (dependency HTMX) install(path string) ! {
	os.chdir('${path}/src/static/js')!
	os.execute('curl -sLO https://raw.githubusercontent.com/freeflowuniverse/weblib/main/htmx/htmx.min.js')
	os.execute('curl -sLO https://unpkg.com/htmx.org@1.9.4/dist/ext/sse.js')
}

fn (dependency HTMX) load() ! {
}
fn (dependency HTMX) update() ! {
}
