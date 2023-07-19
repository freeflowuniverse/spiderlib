module tailwindui

import freeflowuniverse.spiderlib.uikit

import vweb

pub struct TailwindUI{
	vweb.Context
}

pub fn (mut app TailwindUI) index() vweb.Result {
	page := uikit.Page{
		heading: uikit.PageHeading{
			title: 'TailwindUI'
			description: 'UI Elements provided by TailwindUI'
		}
	}
	return $vweb.html()
}

[GET; '/shells/shell']
pub fn (mut app TailwindUI) shells_shell() vweb.Result {
	shell := uikit.Shell{}
	return $vweb.html()
}
