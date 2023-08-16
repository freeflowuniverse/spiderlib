module ssg

import os

const content_path = os.dir(@FILE) + '/example/content'

fn test_new() ! {
	site := new(ssg.content_path)!
	panic(site)
}
