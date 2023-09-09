module dependencies

import os

pub struct TailwindCSS {
	version   string
	installed bool
}

fn install_tailwind() {
}

fn (dependency TailwindCSS) install(path string) ! {
	result := os.execute('which tailwindcss')
	if result.exit_code == 1 {
		// todo: install tailwindcss binary
		// os.execute('')
	}
	if !os.exists('${path}/tailwind.config.js') {
		os.write_file('${path}/tailwind.config.js', $tmpl('./templates/tailwind.config.js'))!
	}
}

fn (dependency TailwindCSS) load() ! {
}

pub fn (dependency TailwindCSS) precompile(path string) ! {
	script := '
	#!/bin/bash
	cd ${path}
	tailwindcss -i ${path}/src/index.css -o ${path}/src/static/css/index.css --minify
	'
	os.execute(script)
}

fn (dependency TailwindCSS) update() ! {
}
