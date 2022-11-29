module ui_kit

import freeflowuniverse.crystallib.pathlib

fn test_button_html() {
	button := Button {
		label: 'Test Button'
	}

	correct_answer := 
'<button>
    Test Button
</button>'

	assert button.html().trim_right('\n') == correct_answer
	
	correct_answer2 := 
'<button>
    Test Button
</button>'

	button2 := Button {
		label: 'Test Button'
		icon: pathlib.get('../../icons/ecommerce.html')
	}
	// assert button2.html().trim_right('\n') == correct_answer
	panic('yo ${button2.html()}')
}