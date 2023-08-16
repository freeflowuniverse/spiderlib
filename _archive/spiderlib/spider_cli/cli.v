module main

import os
import freeflowuniverse.crystallib.params
import freeflowuniverse.spiderlib.spider

fn get_params[T](args []string) T {
	t := T{}
	$for field in T.fields {
		println(field)
	}
	return t
	// mut parameters := params.new_params()
	// for arg, i in args {
	// 	if arg.starts_with('-') && i+1 < args.len {
	// 		parameters.kwarg_add(arg, args[])
	// 	} else {

	// 	}

	// }
	// if os.args.contains(key) {
	// 	if os.args_after(key).len
	// 	return os.args_after(key)[0]
	// } else {}

	// return none
}

fn main() {
	do() or { println('CLI Error: ${err}') }
}

// cli takes in commands and arguments in the following format
// spider_cli [command] [--paramname] [paramvalue] [path]
fn do() ! {
	$if debug {
		eprintln('CLI Arguments: ' + os.args)
	}

	// if no command is specified, return manual
	if os.args.len == 1 {
		manual()
		return
	}

	command := os.args[1]
	// params := get_params(os.args[1..])
	// path := get_path(os.args[1..]) or {'.'} // path is wd if not specified

	match command {
		'create' {
			args := get_params[spider.CreateArgs](os.args)
			spider.create(args)!
		}
		'build' {
			args := get_params[spider.BuildArgs](os.args)
			mut web := spider.load(path: '.')
			web.build()
		}
		'load' {
			args := get_params[spider.LoadArgs](os.args)
			spider.load(args)
		}
		// 'preprocess' { spider.preprocess() }
		'run' {
			mut web := spider.load(path: '.')
			web.run()
		}
		else {}
	}
}

fn manual() {
	print('Help')
	return
}
