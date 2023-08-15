module spider

import os

pub struct ManualParams {
	target string
}

pub fn create_manual(params ManualParams) ! {
	templates := os.dir(@FILE) + '/templates/manual'
	os.mkdir(params.target)!
	os.cp('${templates}/develop.sh', params.target)!
	// write_scripts()
	// os.write()
}
