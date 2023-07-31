module flowbite

type Input = BasicInput

pub struct BasicInput {
pub:
	label       string
	name        string
	typ         string
	placeholder string
}

pub fn (input BasicInput) str() string {
	return $tmpl('templates/input/basic-input.html')
}
