module stripeclient

struct Error {
	code            string
	doc_url         string
	message         string
	param           string
	request_log_url string
	error_type      string
}

enum ErrorCode {
	parameter_missing
	another
}

enum ErrorType {
	invalid_request_error
}

// fn (client StripeClient) handle_error(error Error) {
// 	match error.code {
// 		.parameter_missing {
// 			panic('missing param')
// 		}
// 		else {
// 			panic('Error code not found, this should never happen')
// 		}
// 	}
// }
