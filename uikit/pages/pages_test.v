module pages

fn test_home() {
	home_page := Home {
		title: 'Threefold Ventures'
		description: 'Threefold Ventures'
		background: './image'
		// hero_button: uikit.elements.Button {
		// 	label: 'Get started'
		// 	action: '/login'
		// }
	}
	println(home_page.html())

}