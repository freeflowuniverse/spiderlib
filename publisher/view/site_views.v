module view

import vweb
import os
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.crystallib.publisher2 { Site }
import ui_kit { Button, Component, Dropdown }
import freeflowuniverse.spiderlib.htmx { HTMX }
import ui_kit.partials { Card }
import ui_kit.content { Cards }
import time
import net.html
import json
import net.http

// gets the map of sites accessible by user
// gets and displays site cards for all accesible sites
// returns the sites page in dashboard
pub fn (mut app App) sites() vweb.Result {
	sites := app.get_sites() or {panic(err)}

	// map sites to card partials
	cards := sites.map( 
		Card {
			title: it.name
			subtitle: 'Type: $it.sitetype'
	})


	println('yo $sites')
	cards_page := Cards {
		content: cards
	}
	return app.html(cards_page.html())
}

// returns the
['/site/preview/:site_name']
pub fn (mut app App) site_preview(sitename string) vweb.Result {
	if app.get_header('Hx-Request') != 'true' {
		return app.index()
	}
	mut site := Site{}
	rlock app.publisher {
		site = app.publisher.sites[sitename]
	}

	return $vweb.html()
}

// checks if user has right to access site
// if so responds with site asset requests and injects logger htmx
['/sites/:path...']
pub fn (mut app App) site(path string) vweb.Result {
	
	// site := app.site_get() or {
	// 	handle_redirect(err)
	// }

	
	// HX-Location: {"path":"/test2", "target":"#testdiv"}
	sitename := app.req.url.split('/')[2]
	// checks if there is cached access cookie for site
	access := app.site_get_access(sitename)
	if access.right == .block {
		// TODO: return blocked page
		return app.html('')
	}
	if access.status != .ok {
		requisite := access.status.str().trim_left('.')
		return app.html('
			<head>
				<link rel="stylesheet" type="text/css" href="/static/css/index.css" />
				<script src="/static/htmx.min.js"></script>
			</head>
			<body class="h-full"><span hx-get="/auth/$requisite" hx-trigger="load"></span></body>')
		// return app.auth()
	}

	// TODO: os.read_file('mermaid.js.map') doesn't work
	if path.ends_with('.map') {
		return app.ok('')
	}
	mut response := os.read_file('sites/$path') or { panic('fail: $path, $error') }
	app.set_content_type(app.req.header.get(.content_type) or { '' })

	// injects htmx script to log access to site pages
	if app.req.url.ends_with('.html') {
		mut split_resp := response.split('<body>')
		split_resp[1] = '\n<script src="/static/htmx.min.js"></script>' + split_resp[1]
		response = split_resp.join('<body>')
		response = '<div hx-trigger="every 5s" hx-get="/site_log$app.req.url" hx-swap="none" class="m-20"> $response </div>'
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
