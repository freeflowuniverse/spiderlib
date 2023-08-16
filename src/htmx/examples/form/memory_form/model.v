module main
import vweb
pub struct App {
	vweb.Context
pub mut:
	people shared []Person
}

pub struct Person {
	name string
	age  string
}
