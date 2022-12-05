module pages

pub struct Kanban {
	pub mut:
	boards []KanbanBoard
	template string = 'kanban/kanban.html'
}

pub struct KanbanBoard {
	pub mut:
	id string
	lists []KanbanList
}

pub struct KanbanList {
	pub mut:
	id string
	cards []KanbanCard
}

pub struct KanbanCard {
	pub mut:
	id string
	description string
}