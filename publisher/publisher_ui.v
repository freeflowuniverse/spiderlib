module main

import freeflowuniverse.spiderlib.publisher.api as publisher_api
import freeflowuniverse.spiderlib.publisher.view { run_view }
import freeflowuniverse.spiderlib.publisher.publisher { User, Site }
import freeflowuniverse.spiderlib.api as apilib

import vweb
import time { Time }
import os
import x.json2
import json
import sync
import freeflowuniverse.spiderlib.uikit.shell { Dashboard }
import freeflowuniverse.crystallib.pathlib

fn main() {

	mut publisher := publisher.get() or { panic(err) }

	user_timur := publisher.user_add('timur@threefold.io')

	// new site zanzibar that is accessible to with email
	sitename1 := 'nomads'
	site1 := publisher.site_add(sitename1, .book, '~/code/github/ourworld-tsc/ourworld_books/docs/ourworld_nomads')
	publisher.sites['nomads'].authentication.email_required = true
	publisher.sites['nomads'].authentication.email_authenticated = false

	acl := publisher.acl_add('admins')
	mut ace := publisher.ace_add('admins', .write)
	publisher.ace_add_user(mut ace, user_timur)
	publisher.site_acl_add('admins', acl)

	// new site zanzibar feasibility that requires authenticated email
	sitename2 := 'ourworld_zanzibar_feasibility'
	site2 := publisher.site_add('ourworld_zanzibar_feasibility', .book, '~/code/github/ourworld-tsc/ourworld_books/docs/ourworld_zanzibar_feasibility')
	publisher.sites['ourworld_zanzibar_feasibility'].authentication.email_required = true
	publisher.sites['ourworld_zanzibar_feasibility'].authentication.email_authenticated = true

	mut api := publisher_api.new_app()

	go publisher_api.run(api)
	go run_view()

	for {
		call := <-api.channel

		mut sites := []Site{}


		mut response := ''

		match call.function {
			'get_site' { 
				payload := json.decode(map[string]string, call.payload)!
				mut site := publisher.sites[payload['sitename']]
				user := publisher.users[payload['username']]
				site = user.get_site(site) or {
					response = err.msg Site{}
				}
				if response == '' {
					response = json.encode(site)
				} 
			}
			'get_sites' { 
				user := json.decode(User, call.payload)!
				sites = publisher.get_sites(user) 
				response = json.encode(sites)
			}
			else {}
		} 
		api.response_channel <- &apilib.FunctionResponse{
			thread_id: call.thread_id
			function: call.function
			payload: json.encode(response)
		}
	}
}

// fn send_err_response(err IError, call apilib.FunctionCall) {
// 	api.response_channel <- &apilib.FunctionResponse{
// 		thread_id: call.thread_id
// 		function: call.function
// 		payload: json.encode(err)
// 	}
// }

fn init_publisher() {
	
}
		struct GetSitePayload {
			user User
			sitename string
		}