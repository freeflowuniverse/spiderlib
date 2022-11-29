module view

import vweb
import time { Time }
import os
import ui_kit { Dashboard }
import freeflowuniverse.crystallib.publisher2 { Publisher, User }
import freeflowuniverse.crystallib.pathlib

const (
	port = 8001
)

// pub fn (mut app App) before_request() {
// 	// // builds app from ground up if requested url is fresh
// 	// if app.get_header('Hx-Request') != 'true' {
// 	// 	app.send_response_to_client('text/html', app.index().str())
// 	// }

// 	// TODO: update cookie instead of creating new one
// 	token := app.get_cookie('token') or { '' }
// 	app.user = get_user(token) or { User{} }
// 	updated_token := app.get_cookie('token2') or { '' }
// 	if updated_token != '' {
// 		app.user = get_user(updated_token) or { User{} }
// 		println('ussr: $app.user')
// 	}
// }

fn new_app() &App {
	mut app := &App{}
	app.mount_static_folder_at(os.resource_abs_path('./static'), '/static')
	return app
}

struct App {
	vweb.Context
mut:
	user           User
	email          string
	attempted_url  string
	publisher      shared Publisher
	dashboard      Dashboard
	authenticators shared map[string]Auth
	home           Home
}

struct AccessGroup {
	name string
}

struct Auth {
	max_attempts int = 3
mut:
	timeout       Time
	auth_code     []u8
	attempts      int  = 0
	authenticated bool = false
}

pub fn run_view() {
	mut app := new_app()
	// mut publisher := publisher2.get() or { panic(err) }

	// user_timur := publisher.user_add('timur@threefold.io')

	// // new site zanzibar that is accessible to with email
	// sitename1 := 'nomads'
	// site1 := publisher.site_add(sitename1, .book)
	// mut site_path1 := pathlib.get('~/code/github/ourworld-tsc/ourworld_books/docs/ourworld_nomads')
	// publisher.sites['nomads'].path = site_path1
	// publisher.sites['nomads'].authentication.email_required = true
	// publisher.sites['nomads'].authentication.email_authenticated = false
	// if !os.exists('sites/$sitename1') {
	// 	os.symlink(site_path1.path, 'sites/$sitename1')?
	// }

	// acl := publisher.acl_add('admins')
	// mut ace := publisher.ace_add('admins', .write)
	// publisher.ace_add_user(mut ace, user_timur)
	// publisher.site_acl_add('admins', acl)

	// // new site zanzibar feasibility that requires authenticated email
	// sitename2 := 'ourworld_zanzibar_feasibility'
	// site2 := publisher.site_add('ourworld_zanzibar_feasibility', .book)
	// site_path2 := pathlib.get('~/code/github/ourworld-tsc/ourworld_books/docs/ourworld_zanzibar_feasibility')
	// publisher.sites['ourworld_zanzibar_feasibility'].path = site_path2
	// publisher.sites['ourworld_zanzibar_feasibility'].authentication.email_required = true
	// publisher.sites['ourworld_zanzibar_feasibility'].authentication.email_authenticated = true
	// if !os.exists('sites/$sitename2') {
	// 	os.symlink(site_path1.path, 'sites/$sitename2')?
	// }

	// user_timur := publisher.user_add('timur@threefold.io')
	// publisher.users['timur@threefold.io'].emails = [Email { address: 'timur@threefold.io', authenticated: false }]

	// // site_ace := ACE {
	// // 	users: [user_timur]
	// // 	right: .write
	// // }

	// mut site_acl := publisher.acl_add('zanzibar_acl')
	// //publisher.acls["zanzibar_acl"].entries = [site_ace]

	// site_ace := site_acl.ace_add(.write)

	// auth := site.auth_add(true, false, site_acl)
	// // auth := Authentication {
	// // 	email_required: true
	// // 	email_authenticated: false
	// // 	acl: [site_acl]
	// // }

	// publisher.sites["zanzibar"].authentication = auth

	// lock app.publisher {
	// 	app.publisher = publisher
	// }
	vweb.run(app, port)
}

pub fn (mut app App) index() vweb.Result {
	mut route := 'dashboard'
	if app.get_header('Hx-Request') != 'true' {
		if app.req.url != '/' {
			route = app.req.url.all_after_first('/')
		}
	}
	return $vweb.html()
}
