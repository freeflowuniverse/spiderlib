module api

pub struct FunctionCall {
pub:
	user_id   string // uuid4 of the user calling the function
	thread_id u64
	function  string
	payload   string
}

pub struct FunctionResponse {
pub mut:
	thread_id u64
	function  string
	payload   string
}
