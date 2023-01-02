module view

import vweb
import os
import freeflowuniverse.crystallib.pathlib
import freeflowuniverse.spiderlib.publisher.publisher { Site }
import freeflowuniverse.spiderlib.htmx
import time
import net.html
import json
import net.http

pub fn (mut app App) get_sites() ![]Site {
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})

	data := {
		'user': app.username
	}

	request := http.Request{
		url: 'http://localhost:8080/get_sites'
		method: http.Method.get
		header: header
		data: json.encode(data)
	}
	result := request.do()!
	sites := json.decode([]Site, result.body) or {
		return error('Failed to decode server response into sites: $err')
	}
	return sites
}

// get_site queries the publisher api for a site with given name
// returns Site or error.
fn (mut app App) get_site(sitename string) !Site {
	header := http.new_header_from_map({
		http.CommonHeader.content_type: 'application/json'
	})

	data := {
		'username': app.username
		'sitename': sitename
	}

	mut username := app.username
	if username == '' {
		username = 'guest'
	}

	request := http.Request{
		url: 'http://localhost:8080/get_site/$sitename'
		method: http.Method.get
		header: header
		data: json.encode(data)
	}

	result := request.do()!
	println('result: $result')
	if result.body == 'email_required' {
		return error('email_required')
	}
	site := json.decode(Site, result.body)!
	return site
}
