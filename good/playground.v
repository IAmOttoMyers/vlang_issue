module main

import os

pub struct Alpha {
mut:
	root		Beta
	sources		map[string]&Beta
}

[heap]
pub struct Beta {
mut:
	submodules	[]Beta
}

pub fn (mut a Alpha) setup(path string) ! {
	a.scan(path, mut &a.root)!
}

fn (mut a Alpha) scan(dir string, mut current_root &Beta) ! {
	path := os.norm_path(dir) + "/"
	
	items := os.ls(path)!
	
	println(path)
	println(items)
	
	for i in items {
		item := path + i
		println(item)

		if os.is_file(item) {
			if os.file_ext(item) in [".f"] {
				a.sources[item] = current_root
			}
		}
		
		if os.is_dir(item) {
			current_root.submodules << Beta{}
			a.scan(item, mut current_root.submodules.last())!
		}
	}
}

fn main() {
	mut a := Alpha{}
	a.setup(os.args[1])!
	println(a)
}