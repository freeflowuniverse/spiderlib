module uikit

// the index of the file
// holds metadata and scripts to be imported
pub struct Index {
pub:
	scripts     []string
	stylesheets []string
	shell       Shell
}
