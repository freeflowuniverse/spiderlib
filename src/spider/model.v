module spider

import freeflowuniverse.crystallib.pathlib
import time
import freeflowuniverse.spiderlib.dependencies { IDependency }

pub interface IController {}

pub interface IClient {}

struct Web {
pub:
	name        string
	description string
	path        pathlib.Path
	created_at  time.Time
	updated_at  time.Time
pub mut:
	shell          Shell
	pages          []Page
	dependencies   []IDependency
	authenticators map[string]Authenticator
	controllers    []IController
	clients        []IClient
}

pub struct Authenticator {
	client     string
	controller string
}

pub interface IPage {
	title string
}

pub struct Page {
pub:
	name        string
	title       string
	description string
	template    IPage
}
