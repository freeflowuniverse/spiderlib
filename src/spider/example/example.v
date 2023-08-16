module main

import uikit.elements
import uikit.page
import uikit.partials

fn main() {

    spider :
	= new() // get spider 
    website := spider.new_site()  // create website
    website.model := Registrar {} // attach model
    
    // create registration page
    register_page := page.Register {
        form: partials.Form {
            inputs: [
                elements.NameInput{},
                elements.EmailInput{},
            ]
            action: website.model.register
        }
    }
    
    // create registrations viewing page
    view_registrations := page.Table {
        registrations := website.model.get_registrations
        form: partials.Form {
            inputs: [
                elements.NameInput{},
                elements.EmailInput{},
            ]
            action: website.model.register
        } 
    }

    // add created pages to ui
    website.ui.add_page('register', register_page)
    website.ui.add_page('registrations', view_registrations)

    // generate code, build and run
    spider.weave(website, '.')
}