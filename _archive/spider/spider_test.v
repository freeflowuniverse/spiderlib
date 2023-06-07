module spider

import os

const testpath = os.dir(@FILE) + '/testdata'

fn test_create_plain() ! {
	web := create(
		name: 'testweb'
		path: testpath
	)!

	assert os.exists('$testpath/testweb')
	assert os.exists('$testpath/testweb/testweb.v')
}