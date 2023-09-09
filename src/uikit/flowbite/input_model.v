module flowbite

type Input = BasicInput | InputWithLabel

// pub interface IInput {
// 	html() string
// }

pub struct BasicInput {
pub:
	label       string
	name        string
	typ         string
	placeholder string
}

pub struct InputWithLabel {
pub:
	label       string
	name        string
	typ         string
	placeholder string
	required bool
}

pub struct CheckboxInput {
pub:
	label string
	name string
	id string
	required bool
}
