module uikit

pub interface IInput {
	IComponent
	name string
	label string
}

pub struct Input {
	Component
pub:
	name  string
	label string
}

pub fn (input Input) html() string {
	return $tmpl('./templates/input.html')
}
