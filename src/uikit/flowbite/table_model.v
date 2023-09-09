module flowbite

import freeflowuniverse.spiderlib.uikit

pub interface ITable {
	uikit.IComponent
}

pub struct Table {
	uikit.Component
pub:
	rows []IRow
}

pub interface IRow {
	uikit.IComponent
}

pub struct UserRow {
	uikit.Component
pub:
	name string
	email string
	picture string
	status string
}

pub struct DefaultTable {
pub:
	id      string
	headers []string
	rows    []Row
}


pub struct Row {
pub:
	header string
	items  []string
}

