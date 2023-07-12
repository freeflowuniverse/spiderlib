module spider

import os
import freeflowuniverse.crystallib.pathlib

pub fn (web Web) export() ! {
	os.mkdir_all(web.path.path)!

	web.install()!
	web.export_main()! // create vweb app and main function
	web.export_config()! //
	web.export_index()! //
	web.export_pages()
}

pub fn (web Web) export_main() ! {
	main_path := '$web.path.path/${web.name}.v'
	dollar := '$' // to print dollar sign
	main_str := $tmpl('templates/main.v')
	os.write_file(main_path, main_str)!
}

pub fn (web Web) export_config() ! {
	config_path := '$web.path.path/config.toml'
	config_str := $tmpl('templates/config.toml')
	os.write_file(config_path, config_str)!
}

pub fn (web Web) export_index() ! {
	index_path := '$web.path.path/index.html'
	index_str := $tmpl('templates/index.html')
	os.write_file(index_path, index_str)!
}

pub fn (web Web) export_templates() ! {
	templates_path := '$web.path.path/templates'
	os.mkdir(templates_path)!
}

pub fn (web Web) export_pages() {
	for page in web.pages {
		page.export()
	}
}

pub fn (page Page) export() {
	//todo: make content path
	//todo: export route
}

