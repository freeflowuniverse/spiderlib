module flowbite

import freeflowuniverse.spiderlib.htmx

pub struct AddUserModal {
pub:
	form_htmx htmx.HTMX
}

pub fn (modal AddUserModal) html() string {
	return $tmpl('templates/modals/add-user-modal.html')
}
