module argparse

// fn test_add_argument() {
// 	parser.add_argument(
// 		name: 'command',
// 		nargs: '1',
// 		default_val: 'help'
// 	)
// 	parser.parse_args(['run'])

// parser.parse_args([])
// Namespace(foo=42)
// }

// fn

// fn test_parse_args() {
// 	parser := ArgParser{
// 		name: 'Test Argument Parser'

// 	}
// }

// spider_cli -v create name --overwrite --tailwind --tags test_tag

struct CLIArgs {
	verbose bool
	debug   bool // if true debug is enabled
	command string [cli: positional; required] = 'help'
}

struct CommandArgs {
	name      string   [cli: positional; required]
	overwrite bool
	tailwind  bool
	htmx      bool
	tags      []string
	path      string   [cli: positional; required] = '.'
}

fn test_new_parser() {
	parser := new[CLIArgs]()
	{
	}
	parser2 := new[CommandArgs]()
	{
	}
	args := parser.parse_decode[CLIArgs](['testname', ''])!
	args2 := parser2.parse_decode[CommandArgs](['testapp', '.', '--tailwind', '-v'])!

	panic(args2)
}
