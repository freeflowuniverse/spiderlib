module flowbite

pub fn (input BasicInput) html() string {
	return $tmpl('templates/input/basic-input.html')
}

pub fn (input InputWithLabel) html() string {
	return $tmpl('templates/input/input-with-label.html')
}

pub fn (input CheckboxInput) html() string {
	return $tmpl('templates/input/checkbox.html')
}
