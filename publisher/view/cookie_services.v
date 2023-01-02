module view

import net.smtp
import vweb
import vweb.sse
import time
import rand
import os
import v.ast
import crypto.rand as crypto_rand
import sqlite
import freeflowuniverse.spiderlib.publisher.publisher { Access }
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.spiderlib.auth.jwt

// cookie code inspired from:
// https://github.com/vlang/v/blob/master/examples/vweb/vweb_example.v

// // from vweb_example.v
// pub fn (mut app App) create_cookie() vweb.Result {
// 	token := jwt.make_token(app.user)
// 	app.set_cookie(name: 'token', value: token)
// 	return app.text('Response Headers\n$app.header')
// }

// // from vweb_example.v
// ['/update_user_cookie'; post]
// pub fn (mut app App) update_user_cookie(email string) vweb.Result {
// 	mut user := app.user
// 	user.emails = [Email{address: email, authenticated: true}]
// 	token := jwt.make_token(user)
// 	app.set_cookie(name: 'token2', value: token, path: '/')
// 	return app.ok('')
// }

// // from vweb_example.v
// pub fn (mut app App) create_access_cookie(name string, access Access) {
// 	token := jwt.make_access_token(access, app.username)
// 	app.set_cookie(name: name, value: token)
// }
