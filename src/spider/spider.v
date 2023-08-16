module spider

import os
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session
import freeflowuniverse.spiderlib.auth.tfconnect
import freeflowuniverse.spiderlib.dependencies { IDependency }
import freeflowuniverse.spiderlib.uikit.flowbite
import time
import json
import strconv

[noinit]
struct Spider {
	path string
mut:
	web Web
}

pub fn new(path string) Spider {
	return Spider{
		path: path
	}
}

pub fn (mut spider Spider) create(name string) {
	spider.web = Web{
		name: name
		path: pathlib.get('${spider.path}/${name}')
		created_at: time.now()
	}
}

// pub interface IAuthenticator{}

// pub fn (mut spider Spider) add_authenticator(auth IAuthenticator) {
// 	// if auth is email.Authenticator {
// 	// 	shared auth2 := email.Authenticator{
// 	// 		client: auth.client
// 	// 		auth_route: auth.auth_route
// 	// 	}
// 	// 	spider.web.controllers << email.Controller{
// 	// 		authenticator: auth2
// 	// 	}
// 	// } else if auth is session.Authenticator {
// 	// 	shared auth2 := session.Authenticator{}
// 	// 	spider.web.controllers << session.Controller{
// 	// 		authenticator: auth2
// 	// 	}
// 	// }
// }

pub enum Authentication {
	email
	tfconnect
}

pub fn (mut spider Spider) add_dependency(dependency IDependency) {
	spider.web.dependencies << dependency
}

pub struct Shell {
	name     string
	template ShellTemplate
}

pub type ShellTemplate = flowbite.Shell

pub fn (mut spider Spider) add_shell(shell Shell) {
	spider.web.shell = shell
}

pub type PageTemplate = flowbite.MailboxPage | flowbite.NotFoundPage

pub fn (mut spider Spider) add_page(page Page) {
	spider.web.pages << page
}

pub fn (mut spider Spider) weave() ! {
	spider.web.export()!
	for dependency in spider.web.dependencies {
		dependency.install(spider.path)!
	}
}

[params]
pub struct CreateArgs {
	name         string        [required]
	path         string        [required]
	dependencies []IDependency
}

// creates a new website
pub fn create(args CreateArgs) !Web {
	web := Web{
		name: args.name
		path: pathlib.get('${args.path}/${args.name}')
		dependencies: args.dependencies
		created_at: time.now()
	}
	return web
}

pub fn (web Web) install() ! {
	for dependency in web.dependencies.filter(!it.installed) {
		dependency.install(web.path.path)!
	}
}

pub fn (web Web) precompile() ! {
	for dep in web.dependencies {
		if dep is dependencies.TailwindCSS {
			dep.precompile(web.path.path)!
		}
	}
}

pub fn create_page(page_ Page) Page {
	if page_.description == '' {
	}
	return page_
}

// pub fn (mut web Web) preprocess_tailwind() {

// 	if [[ ! -f "tailwind.config.js" ]]
// 	then
// 		// initialized and configures tailwind if not configured
// 		println("Config file not found, initializing tailwind.")
// 		os.execute('./tailwindcss init')
// 		// sed -i '' "s|  content: \\[\\],|  content: \\['./templates/**/*.html'\\],|g" tailwind.config.js
// 	fi

// 	# compiles tailwind css for prod & builds project
// 	println("Compiling tailwindcss...")
// 	rm -rf public static/css
// 	./tailwindcss -i index.css -o ./static/css/index.css --minify
// }

// pub struct BuildArgs {
// 	name string
// 	path string
// }

// pub fn (mut web Web) build() {
// 	println('Building...')
// }

// pub fn (mut web Web) run() {
// 	web.preprocess()
// }

// pub fn check() {
// 	println('Checking...')
// 	// check_links()
// }

// pub fn fix() {
// 	println('Fixing...')
// 	// fix_links()
// }

// pub struct LoadArgs {
// 	path string
// }

struct Config {
	title        string
	description  string
	dependencies []string
}

pub fn load(path string) !Web {
	config_json := os.read_file('${path}/config.json')!
	config := json.decode(Config, config_json)!
	deps := config.dependencies.map(if it == 'tailwindcss' {
		IDependency(dependencies.TailwindCSS{})
	} else if it == 'htmx' {
		IDependency(dependencies.HTMX{})
	} else {
		IDependency(dependencies.HTMX{})
	})
	return Web{
		path: pathlib.get(path)
		dependencies: deps
	}
}
