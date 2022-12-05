module api

pub struct FunctionCall {
pub:
	thread_id u64
	function string
	payload string
}

pub struct FunctionResponse {
pub:
	thread_id u64
	function string
	payload string
}
