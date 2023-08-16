module main

import freeflowuniverse.spiderlib.auth.email
import freeflowuniverse.spiderlib.auth.session
import log
import vweb

struct App {
	vweb.Context
	vweb.Controller
	users          shared map[string]User
	session_client session.Client         [vweb_global]
	email_client   email.Client           [vweb_global]
mut:
	logger &log.Logger [vweb_global] = &log.Logger(&log.Log{
	level: .debug
})
}

struct User {
mut:
	email     string
	uuid      string
	mailboxes map[string]Mailbox
	contacts  []Contact
}

struct Mailbox {
	name   string
	emails []Email
}

struct Email {
	id      string
	to      string
	from    string
	subject string
	body    string
}

struct Contact {
	name    string
	email   string
	country string
}
