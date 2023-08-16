module spider

import os
import freeflowuniverse.crystallib.pathlib

pub fn (web Web) export() ! {
	os.mkdir_all(web.path.path)!
	web.install()! //
	web.export_source()!
	web.export_scripts()! // create vweb app and main function
	web.export_config()! //
	web.export_index()! //
}

pub fn (web Web) export_static() ! {
	static_dir := '${web.path.path}/src/static'
	if !os.exists(static_dir) {
		os.mkdir(static_dir)!
	}
	if !os.exists('${static_dir}/css') {
		os.mkdir('${static_dir}/css')!
	}
	if !os.exists('${static_dir}/js') {
		os.mkdir('${static_dir}/js')!
	}
	if !os.exists('${static_dir}/images') {
		os.mkdir('${static_dir}/images')!
	}
}

pub fn (web Web) export_source() ! {
	source_dir := '${web.path.path}/src'
	if !os.exists(source_dir) {
		os.mkdir(source_dir)!
	}
	main_path := '${web.path.path}/src/main.v'
	dollar := '$' // to print dollar sign
	main_str := $tmpl('templates/main.v')
	os.write_file(main_path, main_str)!
	web.export_static()!
	web.export_pages()!
}

pub fn (web Web) export_scripts() ! {
	main_path := '${web.path.path}/run.sh'
	os.write_file(main_path, 'run.sh')!
	// os.write_file(main_path, 'precompile.sh')!
}

pub fn (web Web) export_config() ! {
	config_path := '${web.path.path}/config.toml'
	config_str := $tmpl('templates/config.toml')
	os.write_file(config_path, config_str)!
}

pub fn (web Web) export_index() ! {
	index_path := '${web.path.path}/src/index.html'
	index_str := $tmpl('templates/index.html')
	os.write_file(index_path, index_str)!
}

pub fn (web Web) export_templates() ! {
	templates_path := '${web.path.path}/templates'
	os.mkdir(templates_path)!
}

pub fn (web Web) export_pages() ! {
	source_dir := '${web.path.path}/src'
	content_dir := '${source_dir}/content'
	if !os.exists(content_dir) {
		os.mkdir(content_dir)!
	}
	for page in web.pages {
		os.write_file('${content_dir}/${page.name}.md', '')!
		page_str := page.export()
		os.write_file('${source_dir}/${page.name}_view.v', page_str)!

		// page.export()
	}
}

pub fn (web Web) export_shell() ! {
	source_dir := '${web.path.path}/src'
	content_dir := '${source_dir}/content'
	if !os.exists(content_dir) {
		os.mkdir(content_dir)!
	}
	for page in web.pages {
		// println(page)
		os.write_file('${content_dir}/${page.name}.md', '')!
		os.write_file('${source_dir}/${page.name}_view.v', '')!
		// page.export()
	}
}

pub fn (page Page) export() string {
	dollar := '$'
	// todo: make content path
	// todo: export route
	// os.mkdir('')
	return $tmpl('templates/page_view.v')
}
