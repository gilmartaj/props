module props

import os

const (
	example_props_filepath = '../resources/example.properties'
	output_props_filepath  = '../resources/output.properties'
)

fn create_test_props_map() map[string]string {
	mut props_map := map[string]string{}
	props_map['name'] = 'John Rock'
	props_map['birthday_date'] = '2012-12-12'
	props_map['email'] = 'johnrock@fakeemail.com'
	props_map['phone'] = '+1 (111) 11111111'
	props_map['key_with_empty_value'] = ''
	props_map['key_with_empty_value2'] = ''
	props_map[''] = ''
	return props_map
}

fn test_load_from_filepath() {
	props_map := create_test_props_map()
	readed_map := load_from_filepath(props.example_props_filepath) or {
		panic('Error when loading properties.')
	}

	assert props_map.len == readed_map.len
	for key in props_map.keys() {
		assert props_map[key] == readed_map[key]
	}
}

fn test_load_from_file() {
	mut file := os.open(props.example_props_filepath) or { panic('Error when openning file.') }
	defer {
		file.close()
	}
	props_map := create_test_props_map()
	readed_map := load_from_file(mut file) or { panic('Error when loading properties.') }

	assert props_map.len == readed_map.len
	for key in props_map.keys() {
		assert props_map[key] == readed_map[key]
	}
}

fn test_store_to_filepath() {
	props_map := create_test_props_map()
	store_to_filepath(props_map, props.output_props_filepath, 'Test of `store_to_filepath` function') or {
		panic('Error storing properties.')
	}
	readed_map := load_from_filepath(props.output_props_filepath) or {
		panic('Error when loading output properties.')
	}

	assert props_map.len == readed_map.len
	for key in props_map.keys() {
		assert props_map[key] == readed_map[key]
	}
}

fn test_store_to_file() {
	mut file := os.open_file(props.output_props_filepath, 'w+') or {
		panic('Error when openning file.')
	}
	defer {
		file.close()
	}
	props_map := create_test_props_map()
	store_to_file(props_map, mut file, 'Test of `store_to_file` function') or {
		panic('Error storing properties.')
	}
	file.seek(9, .start) or {
		file.close()
		panic('Error seeking to start of file.')
	}
	readed_map := load_from_filepath(props.output_props_filepath) or {
		panic('Error when loading output properties.')
	}

	assert props_map.len == readed_map.len
	for key in props_map.keys() {
		assert props_map[key] == readed_map[key]
	}
}
