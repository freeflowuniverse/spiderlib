module main

import vweb
import json
import freeflowuniverse.spiderlib.api { FunctionCall }
import sync

[post]
pub fn (mut app App) email_verification() vweb.Result {
	data_ := json.decode(map[string]string, app.req.data) or { panic('cannot decode') }
	email := data_['email']

	// sends get_sites function call msg to publisher
	app.channel <- &FunctionCall{
		thread_id: sync.thread_id()
		function: 'email_verification'
		payload: email
	}

	// returns response from function call
	for {
		resp := <-app.response_channel
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	// todo: set timeout
	return app.html('ok')
}

[post]
pub fn (mut app App) is_authenticated() vweb.Result {
	data_ := json.decode(map[string]string, app.req.data) or { panic('cannot decode') }
	email := data_['email']

	// sends get_sites function call msg to publisher
	app.channel <- &FunctionCall{
		thread_id: sync.thread_id()
		function: 'is_authenticated'
		payload: email
	}

	// returns response from function call
	for {
		resp := <-app.response_channel
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	// todo: set timeout
	return app.html('ok')
}

// route of email link
['/authenticate/:email/:cypher']
pub fn (mut app App) authenticate(email string, cypher string) vweb.Result {
	// sends get_sites function call msg to publisher
	app.channel <- &FunctionCall{
		thread_id: sync.thread_id()
		function: 'authenticate'
		payload: json.encode({
			'email':  email
			'cypher': cypher
		})
	}

	// returns response from function call
	for {
		resp := <-app.response_channel
		// todo: check if channel isn't already thread specific
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	// todo: set timeout
	return app.html('ok')
}
