module spider

import os
import time

pub struct CreateArgs {
	name string
	path string
}

pub fn create(args CreateArgs) !Web {

	web := Web {
		name: args.name
		path: args.path
		dependencies: []IDependency
		created_at: time.now()
	}

	os.mkdir(args.name)!

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