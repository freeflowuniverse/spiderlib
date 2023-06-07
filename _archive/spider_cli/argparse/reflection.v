module argparse

// Parser factory that adds arguments automaticaly given a generic type.
fn new[T]() ArgParser {

	// create parser
	mut parser := ArgParser{}

	// t := T{}
	$for field in T.fields {
		// println(T.comments)
		parser.add_argument(
			name: field.name
			typ: field.typ
			required: field.attrs.contains('required')
		)
	}
	return parser
}

// parse_decode decodes arguments into a provided generic type
// it is recommended to use this with a parser created using the generic parser factory
pub fn (parser ArgParser) parse_decode[T](args []string) !T {
	params := parser.parse(args)!
	return params.decode[T]()!
}
