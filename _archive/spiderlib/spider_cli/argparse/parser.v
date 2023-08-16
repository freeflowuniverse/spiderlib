module argparse

struct ArgParser {
	name string
	// commands []Command
	description string
mut:
	args []Argument
}

struct Argument {
	name        string
	labels      []string
	typ         int
	required    bool
	choices     []string
	default_val string
	nargs       u8 // character
	positional  bool
}

fn (mut parser ArgParser) add_argument(arg Argument) {
	parser.args << arg
}
