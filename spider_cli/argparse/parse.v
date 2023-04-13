module argparse

import freeflowuniverse.crystallib.params

// todo: better naming conventions
pub fn (parser ArgParser) parse(args_ []string) !params.Params {
	mut args := args_.clone() // have to mutate so clone
	mut params := params.Params{}

	// loops over arguments in parser, parses arguments, 
	// adds parsed values along keys to params
	for arg in parser.args {
		// doesn't fail if argument isn't required
		value := arg.parse(mut args) or {
			if arg.required { return err }
			continue
		}
		params.kwarg_add(arg.name, value)
	}		
	return params
}

fn (arg Argument) parse(mut args []string) !string {
	// if args.len == 0 {
	// 	return error('Failed to parse argument: $arg.name\n No argument found')
	// }
	if arg.positional {
		return arg.parse_positional(mut args)!
	} 
	// else {
	// 	arg.parse_optional(mut args)!
	// }
	return ''
}

//todo: refactor, very messy
fn (arg Argument) parse_positional(mut args []string) !string {
	mut num := 0
	if arg.nargs.is_digit() {
		num = arg.nargs.ascii_str().int()
	} else if arg.nargs.ascii_str() == '?' {
		// returns default arg value if nargs is optional
		get_arguments(arg.typ, 1, args) or {
			return arg.default
		}
	} else if arg.nargs == 0 {
		// returns error if nargs is not optional
		return get_arguments(arg.typ, 1, args) or {
			return error('Positional argument $arg.name requires one argument.')
		}

	}



	if args.len == 0 {
			return error('Positional argument $arg.name requires at least one argument.')
		}
		val := args[0]
		args = args[1..]
		return val

	// return encoded list of arguments that positional argument expects.
	if num != 0 && !(num < args.len) {
		return error('Failed to parse argument: $arg.name\n Expected $num arguments following positional argument.')
	} else {
		// ensure no flags
		if args[..num].any(it.starts_with('-')) {
			return error('Expected $num arguments following positional argument, but encouontered flag.')
		}
		// todo: check type of args
		args = args[num..] //remove used arguments fron args
		return '${args[..num]}'
	}
	


	// if arg.positional { 
	// 	arg.parse_positional()!
	// } else {
	// 	arg.parse_optional()!
	// }
}


fn get_arguments(amount int, typ int, mut args []string) ![]string {
	
	if args.len == 0 || args.len <= amount {
		return error('Expected $amount arguments but received only ${args.len}')
	}

	mut result := []
	for i in amount {
		if args[i].starts_with('-') {
			return error('Unexpected flag ${args[i]}. Expected $amount arguments.')
		} else if !str_is_type(args[i], typ) {
			return error('Argument ${args[i]} does not match the expected argument type $typ.')
		} else {
			result << args[i]
		}
	}

	args := args[amount..] // remove fetched arguments
	return result
}

fn str_is_type(input string, typ int) bool {
	return true
}