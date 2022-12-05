module view

import vweb
import os
import freeflowuniverse.crystallib.pathlib { Path }
import freeflowuniverse.crystallib.publisher2 { Access, AccessLog, Site }
import freeflowuniverse.spiderlib.uikit
import time
import net.html

// Gets the access level a user has to a site
pub fn (mut app App) site_get_access(name string) Access {
	cookie := app.get_cookie(name) or { '' }
	return get_access(cookie, app.user.name) or {
		mut access := Access{}
		// rlock app.publisher {
		// 	access = app.publisher.get_access(app.user, name)
		// }
		// app.create_access_cookie(name, access)
		return access
	}
}

// pub fn (mut app App) site_get(path string) vweb.Result {

// }

// receives pings every 5 seconds from site's html pages,
// adds logs to the site object including user, timestamp and page
['/site_log/:path...']
pub fn (mut app App) site_log(path string) vweb.Result {
	sitename := path.split('/')[1]

	// log := AccessLog{
	// 	user: app.publisher.users[app.user.name]
	// 	path: Path{
	// 		path: path
	// 	}
	// 	time: time.now()
	// }

	// lock app.publisher {
	// 	app.publisher.sites[sitename].logs << log
	// }
	return app.text('')
}

fn (mut app App) get_access(sitename string) Access {
	mut access := Access{}
	// rlock app.publisher {
	// 	access = app.publisher.get_access(app.user, sitename)
	// }
	return access
}
