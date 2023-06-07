module uikit

import os

pub struct Shell {
	pub:
	logo Image
	homepage string
	navbar Navbar
	sidebar Sidebar
	footer Footer
}

pub struct Image {
	url string
}

fn init() {
	filename := @FILE
	println('file: $filename' + @METHOD)
	println('here: ${os.getwd()}')
	println('here: ${os.args}')
}