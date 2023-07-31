# UIKit

User interface kit for developing vweb applications. Includes UI Components from TailwindUI, Flowbite, alongside custom components.

## Using UIKit

The UIKit can be used two separate ways. The structs in the kit can be imported and served as html code.

## UIKit Component Interfaces

Separate modules in UIKit have separate UI Components, however each of these components implement and/or extend the following common UIKit Component Interfaces. This establishes some consistency in the way common components are implemented, while also allowing uikit modules to add features on top of common functionality.

### Component Interface 

All UIKit Components must have a str() method defined that allows the component to be written in HTML format.

### Index Interface

The Index interface defines an Index structure that contains the outermost HTML of the application. It contains script imports, stylesheet links, and renders the application shell in it. 

### Shell Interface

The UIKit Shell is the container for the application. It holds navigation panes, and a container for page content that changes dynamically with navigation.

```
import vweb
import freeflowuniverse.spiderlib.uikit.<ui_module>

struct App {
	vweb.Context
}

pub fn (mut app App) index() vweb.Result {
	navbar := <ui_module>.Navbar{...}
	sidebar := <ui_module>.Sidebar{...}
	footer := <ui_module>.Footer{...}
	shell := Shell{
		navbar: navbar
		sidebar: sidebar
		footer: footer 
		default: '/home'
	}
	return $vweb.html()
}

```