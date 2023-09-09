module flowbite

import freeflowuniverse.spiderlib.htmx
import freeflowuniverse.spiderlib.uikit

pub fn (page LoginPage) html() string {
	return $tmpl('templates/pages/sign-in.html')
}

pub fn (page NotFoundPage) html() string {
	return $tmpl('templates/pages/not-found.html')
}

pub fn (page ForgotPassword) html() string {
	return $tmpl('templates/pages/forgot-password.html')
}

pub fn (page ProfileLock) str() string {
	return $tmpl('templates/pages/profile-lock.html')
}

pub fn (page ResetPassword) str() string {
	return $tmpl('templates/pages/reset-password.html')
}

pub fn (page SignUp) html() string {
	return $tmpl('templates/pages/sign-up.html')
}

pub fn (page MailboxPage) html() string {
	return $tmpl('templates/pages/mailbox.html')
}

pub fn (page ComposePage) html() string {
	return $tmpl('templates/pages/compose.html')
}

pub fn (page EmailPage) html() string {
	return $tmpl('templates/pages/email.html')
}

pub fn (page FormPage) html() string {
	return $tmpl('templates/pages/form-page.html')
}

pub fn (page UsersPage) html() string {
	return $tmpl('templates/pages/users.html')
}

pub fn (page ProfilePage) html() string {
	return $tmpl('templates/pages/profile.html')
}

pub fn (page SettingsPage) html() string {
	return $tmpl('templates/pages/edit-profile.html')
}

pub fn (page TablePage) html() string {
	return $tmpl('./templates/pages/table-page.html')
}