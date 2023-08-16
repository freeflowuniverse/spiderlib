module ssg

import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.crystallib.texttools
import freeflowuniverse.crystallib.params
import freeflowuniverse.crystallib.installers.mdbook
import v.embed_file
import freeflowuniverse.crystallib.markdowndocs

// add a book to the book collection
// 		name string
// 		path string
pub fn new(path string) !StaticSite {
	mut p := pathlib.get_file(path, false)! // makes sure we have the right path
	if !p.exists() {
		return error('cannot find site on path: ${path}')
	}

	p.path_normalize()! // make sure its all lower case and name is proper
	mut name := ''
	if name == '' {
		name = p.name()
	}

	// is case insensitive
	//? checks for both summary.md files and links
	mut index_path := p.file_get('index.md') or { return error('cannot find index path: ${err}') }

	mut doc := markdowndocs.new(path: index_path.path) or {
		panic('cannot book parse ${index_path} ,${err}')
	}

	mut site := StaticSite{
		name: texttools.name_fix_no_ext(name)
		path: p
		index_doc: doc
	}

	return site
}
