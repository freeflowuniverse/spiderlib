module partials

pub struct Login {
pub:
	heading       string
	login         Action
	remember      Action
	tfconnect_url string
}

pub fn (login Login) render() string {
	current_url := '/home'
	return $tmpl('templates/login.html')
}
