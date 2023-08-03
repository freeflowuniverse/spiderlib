module flowbite_controller

import freeflowuniverse.spiderlib.uikit
import freeflowuniverse.spiderlib.uikit.flowbite
// import freeflowuniverse.spiderlib.uikit.wireframe
import vweb

pub struct Flowbite {
	vweb.Context
}

const tw_link = '<head><link rel="stylesheet" type="text/css" href="/static/css/index.css" /></head>\n'

const mock_navbar = flowbite.Navbar{
	// menu: [
	// 	flowbite.MenuItem{
	// 		label: 'Dashboard'
	// 		route: '/dashboard'
	// 	},
	// 	flowbite.MenuItem{
	// 		label: 'Profile'
	// 		route: '/profile'
	// 	},
	// ]
}

const mock_sidebar = flowbite.Sidebar{
	nav: [
		flowbite.NavButton{
			label: 'Dashboard'
			route: '/dashboard'
		},
		flowbite.NavButton{
			label: 'Profile'
			route: '/profile'
		},
	]
}

const mock_page = uikit.Page{
	title: 'Mock Title'
}

const not_found = flowbite.NotFoundPage {
	title: 'Page not found'
	content: 'Oops! Looks like you followed a bad link. If you think this is a problem with us, please tell us.'
	link: '/'
	button: 'Go back home'
}

const content = flowbite.Content {
	content: 'test'
}

const mock_footer = flowbite.Footer{}

// pub fn (mut app Flowbite) index() vweb.Result {
// 	// page := uikit.Page
// 	// {
// 	// 	heading:
// 	// 	uikit.PageHeading
// 	// 	{
// 	// 		title:
// 	// 		'TailwindUI'
// 	// 		description:
// 	// 		'UI Elements provided by TailwindUI'
// 	// 	}
// 	// }
// 	return $vweb.html()
// }

['/shell'; GET]
pub fn (mut app Flowbite) shell() vweb.Result {
	shell := flowbite.Shell{
		navbar: flowbite_controller.mock_navbar
		sidebar: flowbite_controller.mock_sidebar
		footer: flowbite_controller.mock_footer
		content: flowbite_controller.content	
	}
	return app.html('${flowbite_controller.tw_link}${shell}')
}

// ['/shells/dark_nav_with_page_header'; GET]
// pub fn (mut app Flowbite) shells_dark_nav_with_page_header() vweb.Result {
// 	shell := tailwindui.DarkNavWithPageHeader{
// 		navbar: mock_navbar
// 		page: mock_page
// 	}
// 	return app.html('${tw_link}${shell}')
// }
pub fn (mut app Flowbite) not_found() vweb.Result {
	data := flowbite_controller.not_found
	app.set_status(404, 'Not Found')
	return app.html('${flowbite_controller.tw_link}${data}')
}
