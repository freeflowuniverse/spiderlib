module vapi

import v.ast 
import v.parser

// fn test_parse_module() {
// 	panic(parse_module())
// }

fn test_generate_endpoint() {
	table := ast.new_table()
	file_ast := parser.parse_file('./testdata/testmodule/testmodule.v', table, .parse_comments, fpref)
	fn_stmts := file_ast.stmts.map(fn (it) => {if it is ast.FnDecl {it}) 
	fn_stmt := fn_stmts.map(it.short_name == 'get_aliases3')[0] as ast.FnDecl 

	// test endpoint for get_aliases function generated correctly
	assert generate_endpoint(fn_stmt).trim_right('\n') == 
"pub fn (mut app App) get_aliases3(name string) vweb.Result {

	app.channel <- &FunctionCall {
		thread_id: sync.thread_id()
		function: 'get_aliases3'
		payload: json.encode(name)
	}

	for {
		resp := <- app.response_channel
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	return app.html('ok')
}"
}


// [post]
// pub fn (mut app App) get_sites(token string) vweb.Result {

// 	// sends unathorized response back if jwt isn't verified
// 	if !jwt.verify_jwt(token) {
// 		app.set_status(401, '')
//         return app.text('Not valid token')
// 	}

// 	user := jwt.get_user(token) or {panic(err)}

// 	app.channel <- &FunctionCall {
// 		thread_id: sync.thread_id()
// 		function: 'get_sites'
// 		payload: json.encode(user)
// 	}

// 	for {
// 		resp := <- app.response_channel
// 		if resp.thread_id == sync.thread_id() {
// 			return app.html(resp.payload)
// 		}
// 	}

// 	return app.html('ok')
// }