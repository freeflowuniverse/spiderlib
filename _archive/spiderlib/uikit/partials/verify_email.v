module partials

pub struct VerifyEmail {
pub:
	email string
}

pub fn (verify VerifyEmail) html() string {
	return $tmpl('templates/verify_email.html')
}
