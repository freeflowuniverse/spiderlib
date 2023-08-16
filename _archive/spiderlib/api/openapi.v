module api

import net.http

enum OpenAPIVersion {
	v3
}

struct OpenAPI {
pub:
	version    OpenAPIVersion
	info       OpenAPIInfo
	servers    []string
	components [][]OpenAPIComponent
	paths      []OpenAPIPath
}

struct OpenAPIInfo {
pub:
	version     string
	title       string
	description string
}

struct Schema {}

// Reusable schemas (data models)
struct Parameter {}

// Reusable path, query, header and cookie parameters
struct SecurityScheme {}

// Security scheme definitions (see Authentication)
struct RequestBody {}

// Reusable request bodies
struct Response {}

// Reusable responses, such as 401 Unauthorized or 400 Bad Request
struct Header {}

// Reusable response headers
struct Example {}

// Reusable examples
struct Link {}

// Reusable links
struct Callback {}

// Reusable callbacks

type OpenAPIComponent = Callback
	| Example
	| Header
	| Link
	| Parameter
	| RequestBody
	| Response
	| Schema
	| SecurityScheme

struct OpenAPIPath {
	path   string
	method http.Method
}

struct OpenAPIArgs {
	title       string
	description string
	apipath     string [required]
}

pub fn new(args OpenAPIArgs) OpenAPI {
	mut api := OpenAPI{}
	return api
}

struct GenerateArgs {
	exportpath string
	overwrite  bool = true
}

pub fn (api OpenAPI) generate_definition(args GenerateArgs) {
	$tmpl('./templates/openapi_template.yaml')
}
