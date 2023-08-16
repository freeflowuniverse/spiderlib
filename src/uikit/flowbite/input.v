module flowbite

type Input = BasicInput | InputWithLabel

pub struct BasicInput {
pub:
	label       string
	name        string
	typ         string
	placeholder string
}

pub fn (input BasicInput) html() string {
	return $tmpl('templates/input/basic-input.html')
}

pub struct InputWithLabel {
pub:
	label       string
	name        string
	typ         string
	placeholder string
}

pub fn (input InputWithLabel) html() string {
	return $tmpl('templates/input/input-with-label.html')
}
