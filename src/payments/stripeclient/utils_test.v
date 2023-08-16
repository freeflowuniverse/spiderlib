module stripeclient

import json

// fn test_encode() {
// 	args := SessionArgs{
// 		cancel_url: 'http://localhost:8000/test_cancel_url'
// 		mode: 'payment'
// 		line_items: [LineItem{
// 			price: 'hello'
// 		}]
// 		success_url: 'http://localhost:8000/test_success_url'
// 	}
// 	result := encode<SessionArgs>(args)
// 	panic(result)
// }

fn test_json_to_urlencode() {
	args := SessionArgs{
		cancel_url: 'http://localhost:8000/test_cancel_url'
		mode: 'payment'
		line_items: [LineItem{
			price: 'testprice'
		}]
		success_url: 'http://localhost:8000/test_success_url'
	}
	json_encoded := json.encode(args)
	url_encoded := format(json_encoded, '') or { panic('ogk') }
	assert url_encoded == '%5Bcancel_url%5D=http%3A%2F%2Flocalhost%3A8000%2Ftest_cancel_url&%5Bmode%5D=payment&%5Bsuccess_url%5D=http%3A%2F%2Flocalhost%3A8000%2Ftest_success_url&&&&&%5Bline_items%5D%5B0%5D%5Bprice%5D=testprice&&&&'
}

fn test_index_closing_token() {
	test_string := '{"testdict":[{"testkey": "testvalue"}]}'

	// test openning curly brackets
	mut closing_index := index_closing_token(test_string, 0) or { -1 }
	assert closing_index == 38

	// test openning quotes
	closing_index = index_closing_token(test_string, 1) or { -1 }
	assert closing_index == 10

	// test non-token char index
	closing_index = index_closing_token(test_string, 2) or { -1 }
	assert closing_index == -1

	// test closing double quotes
	closing_index = index_closing_token(test_string, 10) or { -1 }
	assert closing_index == -1

	// test openning square brackets
	closing_index = index_closing_token(test_string, 12) or { -1 }
	assert closing_index == 37

	// test closing square brackets
	closing_index = index_closing_token(test_string, 37) or { -1 }
	assert closing_index == -1
}
