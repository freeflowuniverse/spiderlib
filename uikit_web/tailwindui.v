module uikitweb

import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.uikit.tailwindui
import freeflowuniverse.spiderlib.uikit.wireframe
import vweb

pub struct TailwindUI {
	vweb.Context
}

const tw_link = '<head><link rel="stylesheet" type="text/css" href="/static/css/index.css" /></head>\n'

const mock_navbar = tailwindui.SimpleDarkWithMenuButtonOnLeft{
	menu: tailwindui.Menu{
		items: [
			tailwindui.MenuItem{
				label: 'Dashboard'
				route: '/dashboard'
			},
		]
	}
}

const mock_page = uikit.Page{
	title: 'Mock Title'
}

pub fn (mut app TailwindUI) index() vweb.Result {
	// page := uikit.Page
	// {
	// 	heading:
	// 	uikit.PageHeading
	// 	{
	// 		title:
	// 		'TailwindUI'
	// 		description:
	// 		'UI Elements provided by TailwindUI'
	// 	}
	// }
	return $vweb.html()
}

['/shells'; GET]
pub fn (mut app TailwindUI) tailwindui_shells() vweb.Result {
	cards := [
		wireframe.Card{
			title: 'Test'
			content: '<iframe src="http://localhost:8080/tailwindui/shells/dark_nav_with_page_header" width="900" height="600" frameborder="1"></iframe>'
		},
	]
	return $vweb.html()
}

['/shells/dark_nav_with_page_header'; GET]
pub fn (mut app TailwindUI) shells_dark_nav_with_page_header() vweb.Result {
	shell := tailwindui.DarkNavWithPageHeader{
		navbar: uikit_web.mock_navbar
		page: uikit_web.mock_page
	}
	return app.html('${uikit_web.tw_link}${shell}')
}
