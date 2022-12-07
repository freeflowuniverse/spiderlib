module publisher

// // returns the sites that the user has read or write access to
// pub fn (user User) get_sites() []Site {
// 	mut accesible_sites := []Site{}
// 	for name, site in p.sites {
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