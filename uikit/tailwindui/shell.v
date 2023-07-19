module tailwindui

import uikit

pub struct DarkNavWithPageHeader {
	uikit.Shell
}

pub fn (shell DarkNavWithPageHeader) str() string {
	return $tmpl('./templates/shell/dark_nav_with_page_header.html')
}
