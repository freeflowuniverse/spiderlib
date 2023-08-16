module flowbite

pub struct DefaultTable {
pub:
	id      string
	headers []string
	rows    []Row
}

pub fn (table DefaultTable) html() string {
	return $tmpl('./templates/tables/default-table.html')
}

pub struct Row {
pub:
	header string
	items  []string
}

pub fn (row Row) html() string {
	return $tmpl('./templates/tables/rows/row.html')
}
