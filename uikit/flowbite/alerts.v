module flowbite

import freeflowuniverse.spiderlib.htmx

pub interface IButton {
	html() string
}

pub enum AlertStatus {
	info
	success
}

pub struct AdditionalContent {
pub:
	alert   string
	htmx    htmx.HTMX
	content string
	status  AlertStatus
	buttons  []struct {
	pub:
		label  string
		action htmx.HTMX
	}
}

pub fn (alert AdditionalContent) html() string {
	color_class := match alert.status {
		.info {
			'text-blue-800 border-blue-300 bg-blue-50 dark:bg-gray-800 dark:text-blue-400 dark:border-blue-800'
		}
		.success {
			'text-green-800 border-green-300 bg-green-50 dark:bg-gray-800 dark:text-green-400 dark:border-green-800'
		}
	}
	return $tmpl('templates/alerts/additional-content.html')
}

pub struct AlertWithIcon {
pub:
	alert  string
	status AlertStatus
}

pub fn (alert AlertWithIcon) html() string {
	return $tmpl('templates/alerts/alert-with-icon.html')
}
