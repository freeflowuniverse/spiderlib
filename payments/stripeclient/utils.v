module stripeclient

import json
import maps
import net.http
import net.urllib
import encoding.base64

pub fn format(substring string, prefix string) !string {
	// if substring[0].ascii_str() == '{' {
	// 	end_index := substring.len - substring.reverse().index('}') or {panic('k')}
	// 	return format_map(substring[1..end_index])
	// }
	mut encoded := ''
	mut cursor := 0

	token := substring[0].ascii_str()

	// base case, value to be formatted
	if token == '"' {
		end_cursor := index_closing_token(substring, cursor) or { panic('err0') }
		return format_value(substring[cursor..end_cursor + 1], prefix)
		// array
	} else if substring[cursor].is_alnum() {
		println('yoooo')
		return format_value(substring, prefix)
	} else if token == '[' {
		end_cursor := index_closing_token(substring, cursor) or { panic('err1') }
		return format_array(substring[cursor..end_cursor + 1], prefix)
		// map
	} else if token == '{' {
		end_cursor := index_closing_token(substring, cursor) or { panic('err2') }
		return format_map(substring[cursor..end_cursor + 1], prefix)
	}
	return ''
}

fn format_array(substring string, prefix string) !string {
	mut index := 0
	mut cursor := 1
	mut encoded := ''

	for {
		if cursor >= substring.len - 2 {
			return encoded
		}

		token := substring[cursor].ascii_str()

		// base case, value to be formatted
		if token == '"' {
			cursor = substring.index_after('"', 1)
			value := format_value(substring, prefix)
			if value != '' {
				encoded += '${prefix}[${index}]' + value
			}

			// format recursion
		} else if token == '[' || token == '{' {
			end_cursor := index_closing_token(substring, cursor) or { panic('err4') }
			value := format(substring[cursor..end_cursor + 1], '${prefix}[${index}]')!

			if encoded == '' {
				encoded = value
			} else {
				encoded += '&' + value
			}
			cursor = end_cursor + 1
		} else if token == ',' {
			index += 1
			cursor += 1
		}
	}
	return encoded
}

fn format_value(substring string, prefix string) string {
	if substring == '0' || substring == '""' {
		return ''
	}
	key := urllib.query_escape(prefix)
	value := urllib.query_escape(substring.trim('"'))
	return '${key}=${value}'
}

fn format_map(substring string, prefix string) !string {
	mut key := ''
	mut cursor := 1
	mut encoded := ''
	mut token := substring[cursor].ascii_str()

	for {
		if cursor == substring.len {
			return encoded
		}

		token = substring[cursor].ascii_str()

		if token == '}' {
			return encoded
		}

		if token == '{' || token == '[' {
			end_cursor := index_closing_token(substring, cursor) or { panic('err44') }
			value := format(substring[cursor..end_cursor], '${prefix}[${key}]')!

			if encoded == '' {
				encoded = value
			} else {
				encoded += '&' + value
			}

			cursor = end_cursor + 1
		}
		// key definition
		else if token == '"' {
			key = substring[cursor..].split(':')[0].trim('"')
			println('key: ${key}\n')
			// if key == 'price_data'{
			// 				panic('dvixjdnv: $encoded\n cursor: ${substring[cursor].ascii_str()}')

			// }
			// move cursor to :
			cursor = substring.index_after(':', cursor)
		}
		// value definition
		else if token == ':' {
			println('here')
			if substring[cursor + 1].ascii_str() == '[' || substring[cursor + 1].ascii_str() == '{'
				|| substring[cursor + 1].ascii_str() == '"' {
				end_cursor := index_closing_token(substring, cursor + 1) or { panic('err44') }
				value := format(substring[cursor + 1..end_cursor + 1], '${prefix}[${key}]')!

				if encoded == '' {
					encoded = value
				} else {
					encoded += '&' + value
				}
				cursor = end_cursor + 1
			} else {
				// value is int
				int_str := parse_int(substring[cursor + 1..])
				end_cursor := cursor + 1 + int_str.len
				value := format(substring[cursor + 1..end_cursor], '${prefix}[${key}]')!

				if encoded == '' {
					encoded = value
				} else {
					encoded += '&' + value
				}

				cursor = end_cursor + 1
			}
		} else {
			cursor += 1
		}
	}

	return ''
}

// index closing token receives a substring and the index
// of the token for which the closing token's index will be returned
fn index_closing_token(str string, begin int) ?int {
	mut token := str[begin]
	mut cursor := begin + 1
	pair_tokens := [34, 39] // "" and ''
	symmetric_tokens := [91, 123] // [ and {
	for {
		// closing token not found in substring
		if cursor == str.len {
			break
		}

		curr := str[cursor] // current char ascii

		// pair token closing found
		if curr in pair_tokens && curr == token {
			return cursor
		}
		// symmetric token closing found
		else if token in symmetric_tokens && curr == token + 2 {
			return cursor
		}
		// pair token found that doesn't close current token
		else if curr in pair_tokens && curr != token {
			cursor = index_closing_token(str, cursor) or { return none }
		}
		// symmetric token found that doesn't close current token
		else if curr in symmetric_tokens && curr != token + 2 {
			cursor = index_closing_token(str, cursor) or { return none }
		}

		// increment cursor
		cursor += 1
	}
	return none
}

fn parse_int(str string) string {
	for index, character in str {
		if !character.is_alnum() {
			return str[..index]
		}
	}
	return ''
}

fn urlencode[T](data T) !string {
	mut result := ''
	// compile-time `for` loop
	// T.fields gives an array of a field metadata type
	mut t_val := T{}
	mut encoded_str := ''
	mut pieces := []string{}
	// $for field in T.fields {
	// 	name := data.$(field.name)
	// 	key := urllib.query_escape(field.name)
	// 	mut value := ''
	// 	$if field.typ is string {
	// 		t_val.$(field.name) = 'heyu'
	// 		// $(string_expr) produces an identifier
	// 		if data.$(field.name) != '' {
	// 			pieces << '$key=$value'
	// 		}
	// 	} $else $if field.typ is []string {
	// 		arr := data.$(field.name)
	// 		value = urllib.query_escape('$arr')
	// 		// $(string_expr) produces an identifier
	// 		if data.$(field.name) != [] {
	// 			pieces << '$key=$value'
	// 		}
	// 	}
	// }

	return format(json.encode(data), '')!
}
