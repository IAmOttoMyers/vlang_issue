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

pub fn get_alpha(path string) !Alpha {
	mut result := Alpha{}
	result.scan(path, mut &result.root)!
	return result
}

fn (mut a Alpha) scan(dir string, mut current_root &Beta) ! {
	path := os.norm_path(dir) + "/"
	
	items := os.ls(path)!
	
	println(path)
	println(items)
	
	for i in items {
		item := path + i

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
	println(get_alpha(os.args[1])!)
}