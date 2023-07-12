module api

import v.ast
import v.parser
import v.pref

const (
	fpref = &pref.Preferences{
		is_fmt: true
	}
)


fn parse_module() string {
	table := ast.new_table()
	file_ast := parser.parse_file('./testdata/testmodule/testmodule.v', table, .parse_comments, fpref)

	for stmt in file_ast.stmts {
		if stmt is ast.FnDecl {
			fn_stmt := stmt as ast.FnDecl 
			if fn_stmt.is_pub {
				generate_endpoint(fn_stmt)
				// panic('het: $fn_stmt.short_name \n $fn_stmt.params \n $fn_stmt.has_return \n $fn_stmt.return_type \n $fn_stmt.comments \n $fn_stmt.end_comments \n $fn_stmt.next_comments')
			}
		}
	}

	// panic('here: ${file_ast.stmts[2]}')
	// return $tmpl('./templates/endpoint_template.v')
	return ''
}

fn generate_endpoint(fn_stmt ast.FnDecl) string {
	fn_name := fn_stmt.short_name
	fn_param_name := fn_stmt.params[0].name

	return $tmpl('./templates/endpoint_template.v')

}