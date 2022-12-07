module publisher

import freeflowuniverse.crystallib.pathlib { Path }
import freeflowuniverse.crystallib.texttools
import net.html
import os

// adds site from existing path
pub fn (mut p Publisher) site_add(name_ string, type_ SiteType, path_ string) &Site {
	mut name := texttools.name_fix(name_)
	path := pathlib.get(path_)
	mut site := Site{
		name: name
		path: path
		publisher: &p
		sitetype: type_
	}
	site.update_info()
	p.sites[name] = site
	return &site
}

// scans metadata in site's index, adds info to struct
fn (mut site Site) update_info() {
	mut site_index := os.read_file('$site.path.path/index.html') or {
		panic("Failed to read site's index.html: $err")
	}

	mut parsed := html.parse(site_index)
	site.title = parsed.get_tag('title')[0].content
	site.description = parsed.get_tag_by_attribute_value('name', 'description')[0].content
	site.description = 'value nation wealth manufacturing which swim grabbed pick thee further dirt rock work pet hope selection call fun consist heart guard run bare jackage railroad drive number special out zoo fastened wide party divide card tax property beneath native shot line apart beat immediately lake stock dish'
}

pub fn (p Publisher) get_sites(user User) []Site {
	mut accesible_sites := []Site{}
	for name, site in p.sites {
		user_right := site.get_right(p.users[user.name])
		if user_right == Right.read || user_right == Right.write {
			accesible_sites << site
		}
	}
	return accesible_sites
}

// returns the right a user has to a given site
// if a user can access, but requires email, considered to have reading right
fn (site Site) get_right(user User) Right {
	mut right := Right.block
	auth := site.authentication
	if auth.acl.len > 0 {
		// loops acl to find user or user_group entry
		for list in auth.acl {
			for entry in list.entries.filter(it.right != .block) {
				for group in entry.groups.filter(it.users.any(it.name == user.name)) {
					right = entry.right
				}
				if entry.users.any(it.name == user.name) {
					right = entry.right
				}
			}
		}
	// assumes read right if no acl
	} else { right = Right.read }
	return right
}