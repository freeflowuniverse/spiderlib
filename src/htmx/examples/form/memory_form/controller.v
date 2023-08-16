module main

fn (app App) get_people() []Person {
	rlock app.people {
		people := app.people // clone shared
		return people
	}
	return []
}

fn (app App) add_person(person Person) {
	lock app.people {
		app.people << person
	}
}
