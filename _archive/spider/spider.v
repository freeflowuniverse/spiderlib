module spider

import os
import freeflowuniverse.crystallib.pathlib
import time

[params]
pub struct CreateArgs {
	name string [required]
	path string [required]
	dependencies []IDependency
}

// creates a new website
pub fn create(args CreateArgs) !Web {

	web := Web {
		name: args.name
		path: pathlib.get('$args.path/$args.name')
		dependencies: args.dependencies
		created_at: time.now()
	}

	web.export()!
	return web
}


pub fn (web Web) install()! {
	for dependency in web.dependencies.filter(!it.installed){
		dependency.install()!
	}
}

pub fn (web Web) update()! {
	for dependency in web.dependencies{
		dependency.update()!
	}
}

pub fn (mut web Web) preprocess() {
	// preprocess_uikit()
	preprocess_tailwind()
}

pub fn (mut web Web) preprocess_tailwind() {
	

	if [[ ! -f "tailwind.config.js" ]]
	then
		// initialized and configures tailwind if not configured
		println("Config file not found, initializing tailwind.")
		os.execute('./tailwindcss init')
		// sed -i '' "s|  content: \\[\\],|  content: \\['./templates/**/*.html'\\],|g" tailwind.config.js
	fi

	# compiles tailwind css for prod & builds project
	println("Compiling tailwindcss...")
	rm -rf public static/css
	./tailwindcss -i index.css -o ./static/css/index.css --minify
}

pub struct BuildArgs {
	name string
	path string
}

pub fn (mut web Web) build() {
	println('Building...')
}

pub fn (mut web Web) run() {
	web.preprocess()
}

pub fn check() {
	println('Checking...')
	// check_links()
}

pub fn fix() {
	println('Fixing...')
	// fix_links()
}

pub struct LoadArgs {
	path string
}

pub fn load(args LoadArgs) Web {
	return Web{}
}