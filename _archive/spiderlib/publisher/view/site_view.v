module view

import vweb
import os
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.spiderlib.publisher.publisher { Site }
import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit.partials { Card }
import freeflowuniverse.spiderlib.uikit.pages { Cards }
import freeflowuniverse.spiderlib.uikit.elements { LinkButton }
import time
import net.html
import json
import net.http

// gets the map of sites accessible by user
// gets and displays site cards for all accesible sites
// returns the sites page in dashboard
pub fn (mut app App) sites() vweb.Result {
	sites := app.get_sites() or { panic(err) }

	// map sites to card partials
	cards := sites.map(Card{
		htmx: htmx.navigate('site/preview/${it.name}')
		title: it.title
		subtitle: '${it.sitetype}'
		description: it.description
		footer: [
			LinkButton{
				label: 'Open Site'
				src: '/sites/${it.name}/index.html'
				target: '_blank'
			},
		]
	})
	println('card: ${cards}')

	cards_page := Cards{
		content: cards
	}
	return app.html(cards_page.html())
}

// returns the preview of the site
// if owner, can view logs and manage access
['/site/preview/:site_name']
pub fn (mut app App) site_preview(sitename string) vweb.Result {
	if app.get_header('Hx-Request') != 'true' {
		return app.index()
	}
	mut site := app.get_site(sitename) or { panic('err') }

	preview_page := pages.PreviewPage{
		title: site.title
		description: site.description
		owner: 'site.owner'
		created_at: 'site.created_at'
	}

	return app.html(preview_page.html())
}

// gateway to viewing the site
// if user can access site, site is mounted and function redirects to mount url
// otherwise redirects to auth views
['/site/view/:sitename']
pub fn (mut app App) site_view(sitename string) vweb.Result {
	site := app.get_site(sitename) or {
		if err.msg == 'email_required' {
			return app.redirect('/login')
		} else {
			panic('error: ${err}')
		}
		Site{}
	}

	app.mount_static_folder_at(os.resource_abs_path('testfolder'), '/testurl')

	// return app.redirect('/sites/$sitename/index.html')
	return app.redirect('/sites/${sitename}/index.html')
}

// checks if user has right to access site
// if so responds with site asset requests and injects logger htmx
['/sites/:path...']
pub fn (mut app App) site(path string) vweb.Result {
	// TODO: os.read_file('mermaid.js.map') doesn't work
	if path.ends_with('.map') {
		return app.ok('')
	}

	mut response := os.read_file('sites/${path}') or {
		println('fail: ${path}, ${error}')
		''
	}
	app.set_content_type(app.req.header.get(.content_type) or { '' })

	// injects htmx script to log access to site pages
	if app.req.url.ends_with('.html') {
		mut split_resp := response.split('<body>')
		split_resp[1] = '\n<script src="/static/htmx.min.js"></script>' + split_resp[1]
		response = split_resp.join('<body>')
		response = '<div hx-trigger="every 5s" hx-get="/site_log${app.req.url}" hx-swap="none" class="m-20"> ${response} </div>'
	}

	return app.ok(response)
}

// // returns the card view of site with given name
// ['/site_card/:name']
// pub fn (mut app App) site_card(name string) vweb.Result {
// 	mut site := app.get_site(name)
// 	mut access := app.site_get_access(name)
// 	mut site_index := os.read_file('sites/$name/index.html') or {
// 		panic("Failed to read site's index.html: $err")
// 	}

// 	mut parsed := html.parse(site_index)
// 	title := parsed.get_tag('title')[0].content
// 	mut description := parsed.get_tag_by_attribute_value('name', 'description')[0].content
// 	description = 'value nation wealth manufacturing which swim grabbed pick thee further dirt rock work pet hope selection call fun consist heart guard run bare jackage railroad drive number special out zoo fastened wide party divide card tax property beneath native shot line apart beat immediately lake stock dish'
// 	metadata := parsed.get_tag('meta')

// 	mut preview_site := Button{
// 		label: 'Preview Site'
// 		hx: HTMX{
// 			get: '/dashboard/sites/preview/$name'
// 			target: '#dashboard-container'
// 		}
// 	}

// 	mut open_site := Button{
// 		label: 'Open Site'
// 		hx: HTMX{
// 			get: '/sites/$name/index.html'
// 			target: '_blank'
// 		}
// 	}

// 	mut share_dropdown := Dropdown{
// 		label: 'Share'
// 		options: [
// 			Button{
// 				label: 'Send Email'
// 				hx: HTMX{
// 					get: 'share_site/email'
// 				}
// 			}
// 		]
// 	}

// 	site_card := Card{
// 		title: title
// 		subtitle: 'book'
// 		description: description
// 		footer: [share_dropdown]
// 	}

// 	return app.html(site_card.html())
// }
