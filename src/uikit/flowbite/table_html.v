module flowbite

pub fn (table Table) html() string {
	return $tmpl('templates/tables/user-table.html')
}

pub fn (table DefaultTable) html() string {
	return $tmpl('./templates/tables/default-table.html')
}

pub fn (row Row) html() string {
	return $tmpl('./templates/tables/rows/row.html')
}

pub fn (row UserRow) html() string {
	return $tmpl('templates/tables/rows/user-row.html')
}
