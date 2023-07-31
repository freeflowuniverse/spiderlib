module flowbite

import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.htmx

pub struct Shell {
	uikit.Shell
	router map[string]string
}

pub fn (shell Shell) str() string {
	return $tmpl('./templates/shell.html')
}

pub struct NavItem {
	uikit.MenuItem
pub:
	icon string
}

pub struct Footer {
	uikit.Footer
}

pub fn (sidebar Footer) str() string {
	return $tmpl('./templates/footer.html')
}
