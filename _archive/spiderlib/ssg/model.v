module ssg

import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.crystallib.markdowndocs

struct StaticSite {
	name string
	title string
	description string
	pages []Page
	index_doc markdowndocs.Doc
	path pathlib.Path
}

struct Page {
	path pathlib.Path
	title string
	description string
	author string
	pages []Page
	assets []Asset
}

struct Asset {}