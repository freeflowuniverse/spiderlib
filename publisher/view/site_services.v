module view

import vweb
import os
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.spiderlib.publisher.publisher { Site }
import freeflowuniverse.spiderlib.htmx { HTMX }
import time
import net.html
import json
import net.http

pub fn (mut app App) get_sites() ![]Site {

	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json',
	})

	data := {
		'user': 'user.name'
	}

	request := http.Request{
		url: "http://localhost:8001/get_sites"
		method: http.Method.post
		header: header,
		data: json.encode(data),
	}
	result := request.do()!
	sites := json.decode([]Site, result.body) or {panic('nasss: $err')}
	return sites
}


// getter function for site, return site with given name
fn (mut app App) get_site(sitename string) !Site {
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json',
	})

	data := {
		'username': app.user.name
		'sitename': sitename
	}

	mut username := app.user.name
	if username == '' {
		username = 'guest'
	}

	request := http.Request{
		url: "http://localhost:8001/get_site/$username/$sitename"
		method: http.Method.get
		header: header,
		data: json.encode(data),
	}

	result := request.do()!
	println('result: $result')
	if result.body == 'email_required' {
		return error('email_required')
	}
	site := json.decode(Site, result.body)!
	return site
}
