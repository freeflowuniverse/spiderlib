module argparse

import freeflowuniverse.crystallib.params

struct TestCase {
	input  []string
	output params.Params
}

fn generate_test_cases() []TestCase {
	return [
		TestCase{
			input: ['testvalue']
			output: params.Params{
				params: [params.Param{
					key: 'positional_arg1'
					value: 'testvalue'
				}]
			}
		},
	]
}

fn generate_parser() ArgParser {
	mut parser := ArgParser{
		name: 'testname'
	}

	parser.add_argument(name: 'positional_arg1')
	return parser
}

fn test_parse_positional() {
	parser := generate_parser()
	cases := generate_test_cases()
	mut input := []string{}
	mut value := ''

	// default positional argument
	argument := Argument{
		name: 'positional_argument'
	}

	// single arg input
	input = ['testvalue']
	value = argument.parse_positional(mut input)!
	assert value == 'testvalue'
	assert input == []

	// multiple arg input
	input = ['testvalue', 'testvalue2']
	value = argument.parse_positional(mut input)!
	assert value == 'testvalue'
	assert input == ['testvalue2']

	// empty arg input, should return error
	input = []
	value = argument.parse_positional(mut input) or {
		assert err.msg == 'Positional argument positional_argument requires at least one argument.'
		'error'
	}
	assert input == []
	assert value == 'error'

	// positional argument expecting optional argument
	argument1 := Argument{
		name: 'positional_argument'
	}

	// single arg input
	input = ['testvalue']
	value = argument.parse_positional(mut input)!
	assert value == 'testvalue'
	assert input == []

	// multiple arg input
	input = ['testvalue', 'testvalue2']
	value = argument.parse_positional(mut input)!
	assert value == 'testvalue'
	assert input == ['testvalue2']

	// empty arg input, should return error
	input = []
	value = argument.parse_positional(mut input) or {
		assert err.msg == 'Positional argument positional_argument requires at least one argument.'
		'error'
	}
	assert input == []
	assert value == 'error'

	// for case in cases {
	// 	params := parser.parse(case.input)!
	// 	assert case.output == params
	// }
}
