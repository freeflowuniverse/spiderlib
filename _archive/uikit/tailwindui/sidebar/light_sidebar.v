module sidebar

struct LightSidebar {
pub:
	links []Link
}

struct Link {
pub:
	icon  string
	label string
}

pub fn (sidebar LightSidebar) html() string {
	return $tmpl('templates/light_sidebar.html')
}
