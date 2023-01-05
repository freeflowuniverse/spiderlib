module publisher

import freeflowuniverse.spiderlib.user

[heap]
pub struct User {
	user.User
pub:
	sites_user   map[string]Site // sites that a user owns
	sites_shared []SiteAddress   // addresses of sites shared with user
}

pub struct SiteAddress {
	owner    string
	sitename string
}

// // returns the sites that the user has read or write access to
// pub fn (user User) get_sites() []Site {
// 	mut sites := user.sites.values()
// 	for site_addr in user.sites_shared {
// 		owner.get_site
// 		user_access := p.get_access(p.users[user.name], name)
// 		if user_access.right == Right.read || user_access.right == Right.write {
// 			accesible_sites << site
// 		}
// 	}
// 	return accesible_sites
// }

pub fn (user User) get_site(site Site) !Site {
	user_right := site.get_right(user)
	if user_right != Right.read && user_right != Right.write {
		return error('unauthorized')
	}
	if site.authentication.email_required && user.emails.len == 0 {
		return error('email_required')
	}
	if site.authentication.email_authenticated && user.emails.len == 0 {
		return error('email_auth_required')
	}
	return site
}
