module props

import os

// `buffer_len` buffer size of file read buffer
const buffer_len = 1024

// `load_from_file` load properties of a file to map with the readed properties.
pub fn load_from_file(mut file os.File) !map[string]string {
	mut props_map := map[string]string{}
	buffer := [props.buffer_len]u8{}
	mut content := []u8{}

	for !file.eof() {
		readed_len := file.read_into_ptr(&buffer[0], props.buffer_len)!
		content << buffer[..readed_len]
	}
	file.close()

	props_lines := content.bytestr().split_into_lines().map(it.trim_space()).filter(it.len > 0
		&& !it.starts_with('#'))
	for line in props_lines {
		if sep_index := line.index('=') {
			props_map[line.substr(0, sep_index).trim_space()] = line.substr(sep_index + 1,
				line.len).trim_space()
		} else {
			props_map[line.trim_space()] = ''
		}
	}
	return props_map
}

// `load_from_filepath` load properties of the file in filepath to map with the readed properties.
pub fn load_from_filepath(filepath string) !map[string]string {
	mut props_map := map[string]string{}
	mut props_lines := os.read_lines(filepath)!.map(it.trim_space()).filter(it.len > 0
		&& !it.starts_with('#'))
	for line in props_lines {
		if sep_index := line.index('=') {
			props_map[line.substr(0, sep_index).trim_space()] = line.substr(sep_index + 1,
				line.len).trim_space()
		} else {
			props_map[line.trim_space()] = ''
		}
	}
	return props_map
}

// `store_to_filepath` write the properties of a map on file in the filepath.
// Comments are putted in the initial lines of file.
pub fn store_to_filepath(props_map map[string]string, filepath string, comments ...string) ! {
	mut file := os.open_file(filepath, 'w')!
	defer {
		file.close()
	}
	store_to_file(props_map, mut file, ...comments)!
}

// `store_to_filepath` write the properties of a map on file in the filepath.
// Comments are putted in the initial lines of file.
pub fn store_to_file(props_map map[string]string, mut file os.File, comments ...string) ! {
	for comment in comments {
		file.writeln('# ${comment}')!
	}
	if comments.len > 0 {
		file.writeln('')!
	}
	for key in props_map.keys() {
		file.writeln('${key}=${props_map[key]}')!
		file.flush()
	}
}
