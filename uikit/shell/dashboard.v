module ui_kit
import vweb

struct App {
	vweb.Context
}

pub struct Dashboard {
pub mut:
	logo_path string
	navbar Navbar
	sidebar string
	footer string
	default_content string
	template string = "./dashboard.html"
	router string
	output string
}

pub fn (dashboard Dashboard) render() string {
	current_url:= '/home'
	return $tmpl('templates/layouts/dashboard.html')
}

pub fn (login Login) render() string {
	current_url:= '/home'
	return $tmpl('templates/auth/login.html')
}

pub fn (navbar Navbar) render() string {
	current_url:= '/home'
	return $tmpl('templates/components/navbar.html')
}