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
		url: "http://localhost:8080/get_sites"
		method: http.Method.post
		header: header,
		data: json.encode(data),
	}
	result := request.do()!
	sites := json.decode([]Site, result.body)!
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

	request := http.Request{
		url: "http://localhost:8080/get_site"
		method: http.Method.post
		header: header,
		data: json.encode(data),
	}
	result := request.do()!
	site := json.decode(Site, result.body)!
	return site
}
