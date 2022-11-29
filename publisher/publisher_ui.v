module main

import timurgordon.publisher_ui.controller { run_controller }
import timurgordon.publisher_ui.view { run_view }
import timurgordon.publisher_ui.publisher2 { User, Site }
import timurgordon.publisher_ui.vapi 

import vweb
import time { Time }
import os
import json
import sync
import ui_kit { Dashboard }
import freeflowuniverse.crystallib.pathlib


fn main() {

	mut publisher := publisher2.get() or { panic(err) }

	user_timur := publisher.user_add('timur@threefold.io')

	// new site zanzibar that is accessible to with email
	sitename1 := 'nomads'
	site1 := publisher.site_add(sitename1, .book)
	mut site_path1 := pathlib.get('~/code/github/ourworld-tsc/ourworld_books/docs/ourworld_nomads')
	publisher.sites['nomads'].path = site_path1
	publisher.sites['nomads'].authentication.email_required = true
	publisher.sites['nomads'].authentication.email_authenticated = false
	if !os.exists('sites/$sitename1') {
		os.symlink(site_path1.path, 'sites/$sitename1')?
	}

	acl := publisher.acl_add('admins')
	mut ace := publisher.ace_add('admins', .write)
	publisher.ace_add_user(mut ace, user_timur)
	publisher.site_acl_add('admins', acl)

	// new site zanzibar feasibility that requires authenticated email
	sitename2 := 'ourworld_zanzibar_feasibility'
	site2 := publisher.site_add('ourworld_zanzibar_feasibility', .book)
	site_path2 := pathlib.get('~/code/github/ourworld-tsc/ourworld_books/docs/ourworld_zanzibar_feasibility')
	publisher.sites['ourworld_zanzibar_feasibility'].path = site_path2
	publisher.sites['ourworld_zanzibar_feasibility'].authentication.email_required = true
	publisher.sites['ourworld_zanzibar_feasibility'].authentication.email_authenticated = true
	if !os.exists('sites/$sitename2') {
		os.symlink(site_path1.path, 'sites/$sitename2')?
	}

	mut server := controller.new_app()

	go controller.run(server)
	go run_view()

	for {
		call := <-server.channel

		mut sites := []Site{}
		match call.function {
			'get_sites' { 
				user := json.decode(User, call.payload)!
				sites = publisher.get_sites(user) 
			}
			else {}
		} 
		server.response_channel <- &vapi.FunctionResponse{
			thread_id: call.thread_id
			function: call.function
			payload: json.encode(sites)
		}
	}
}