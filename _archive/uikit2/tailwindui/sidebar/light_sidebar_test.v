module sidebar

fn test_html() {
	sidebar := LightSidebar{
		links: [
			Link {
				label: 'Home'
				icon: ''
			}, Link {
				label: 'About'
				icon: ''
			}
		]
	}

	println(sidebar.html())
	panic('s')
}


struct Chapter {
	title: 
	description:
	content: 
	reading_time: 
}

fn index() {

	mut links := []Link{}
	for chapter in book.chapters {
		links << Link{
			chapter.title
		}
	}


	// links := book.chapter.map()

	sidebar := LightSidebar {
		links: links
	}
	sidebar.
}

fn about() {

	about := Book {
		content string
		title string
	}

	markdownpage := {
		title: about.title
		description: about.description
	}

}