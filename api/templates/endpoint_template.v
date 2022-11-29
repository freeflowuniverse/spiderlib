pub fn (mut app App) @{fn_name}(@{fn_param_name} string) vweb.Result {

	app.channel <- &FunctionCall {
		thread_id: sync.thread_id()
		function: '@{fn_name}'
		payload: json.encode(@{fn_param_name})
	}

	for {
		resp := <- app.response_channel
		if resp.thread_id == sync.thread_id() {
			return app.html(resp.payload)
		}
	}

	return app.html('ok')
}