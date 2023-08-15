module main

import freeflowuniverse.spiderlib.spider
// import freeflowuniverse.spiderlib.auth.session
// import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.dependencies
import freeflowuniverse.spiderlib.uikit.flowbite
import net.smtp
import os

fn main() {
	threemail_path := '${os.dir(os.dir(@FILE))}'

	mut nephilia := spider.new(threemail_path)
	nephilia.create('threemail')

	// add dependencies
	nephilia.add_dependency(dependencies.HTMX{})
	nephilia.add_dependency(dependencies.TailwindCSS{})

	// // add authentication
	// nephilia.add_authenticator(email.Authenticator{
	// 	auth_route: ''
	// 	client: smtp.Client{
	// 		server: 'smtp-relay.brevo.com'
	// 		from: 'verify@authenticator.io'
	// 		port: 587
	// 	}
	// })

	// nephilia.add_authenticator(session.Authenticator{})

	// add shell and pages
	nephilia.add_shell(template: flowbite.Shell{})

	nephilia.add_page(
		name: 'inbox'
		template: flowbite.MailboxPage{}
	)

	nephilia.add_page(
		name: 'not_found'
		template: flowbite.NotFoundPage{}
	)

	nephilia.add_page(
		name: 'outbox'
		template: flowbite.MailboxPage{}
	)

	nephilia.add_page(
		name: 'compose'
		template: flowbite.ComposePage{}
	)

	nephilia.add_page(
		name: 'email'
		template: flowbite.MailboxPage{}
	)
	nephilia.weave()!
}
