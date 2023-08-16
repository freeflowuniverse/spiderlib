module wireframe

import uikit

pub struct WireframeShell {
	uikit.Shell
pub:
	page   uikit.Page
	navbar uikit.INavbar
}

pub fn (shell WireframeShell) str() string {
	return $tmpl('./templates/shell.html')
}

pub struct Page {
	uikit.Page
}

pub fn (page Page) str() string {
	return $tmpl('./templates/page.html')
}

pub struct Card {
	uikit.Card
}

pub fn (card Card) str() string {
	return $tmpl('./templates/card.html')
}
