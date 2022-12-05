module htmx


// replaces inner html of main tag 
// with response from route, used for navigation
pub fn navigate(route string) HTMX {
	return HTMX{
		get: route
		push_url: 'true'
		target: '#dashboard-container'
	}
}