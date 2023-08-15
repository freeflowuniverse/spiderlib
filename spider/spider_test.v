module spider

import os

const testpath = os.dir(@FILE) + '/testdata'

fn test_create_plain() ! {
	web := create(
		name: 'testweb'
		path: spider.testpath
	)!
	web.export()!

	assert os.exists('${spider.testpath}/testweb')
	assert os.exists('${spider.testpath}/testweb/src/testweb.v')
}

fn test_add_page() ! {
	mut web := create(
		name: 'testweb'
		path: spider.testpath
	)!

	web.add_page(
		name: 'profile'
		title: 'Profile'
	)
	web.export()!

	assert os.exists('${spider.testpath}/testweb')
	assert os.exists('${spider.testpath}/testweb/src/testweb.v')
}
