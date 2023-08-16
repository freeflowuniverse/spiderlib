module flowbite

pub type Dropdown = AppsDropdown | NotificationDropdown

pub struct AppsDropdown {
	title string
	apps  []AppButton
}

pub struct NotificationDropdown {
	title string
	rows  []struct {
		image string
		text  string
		time  string
	}

	view_all string
}
