module htmx

[params]
pub struct NavigateParams {
	route string [required] // route which will be navigated to.
}

// replaces inner html of main tag
// with response from get request to route, used for navigation
pub fn navigate(params NavigateParams) HTMX {
	return HTMX{
		get: params.route
		push_url: 'true'
		target: '#outlet'
	}
}

[params]
pub struct OutletParams {
	default string [required] // route which the outlet will default to (ex: /home)
}

// outlet creates an htmx struct that acts as an outlet for navigation
pub fn outlet(params OutletParams) HTMX {
	return HTMX{
		get: params.default
		trigger: 'load'
	}
}

[params]
pub struct FormParams {
	post_path string [required] // route which the form post will be done to
}

// form creates an htmx struct for form submission
pub fn form(params FormParams) HTMX {
	return HTMX{
		post: params.post_path
	}
}

// pub fn waiting_response() HTMX {

// }
