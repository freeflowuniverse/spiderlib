module main

import freeflowuniverse.spiderlib.uikit.flowbite
import net.http

fn (app App) get_rows() []flowbite.Row {
	people := app.get_people()
	return people.map(flowbite.Row{
		header: it.name
		items: [it.age]
	})
}

fn (app App) add_row(data_ string) flowbite.Row {
	data := http.parse_form(data_)
	name := data['name']
	age := data['age']
	person := Person {
		name: name
		age: age
	}
	app.add_person(person)
	return flowbite.Row{
		header: name
		items: [age]
	}
}