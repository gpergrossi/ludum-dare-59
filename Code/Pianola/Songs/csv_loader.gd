# @author Vivian

class_name CsvLoader extends Node

const prefixes = ["res://", "user://"];

# Returns an array of dictionaries representing the data lines of the .csv file.
# Returns [] if file fails to read for any reason.
static func load(filepath: String, prefix: String = "res://") -> Array[Dictionary]:
	var path := filepath;
	if (not prefixes.any(func(p): return path.begins_with(p))): path = prefix + path;
	
	var file := FileAccess.open(path, FileAccess.READ);

	if (not file):
		push_error("CsvLoader.load(...): Failed to open file at '{path}'.")
		return [];

	var data: Array[Dictionary] = [];

	var headers := file.get_csv_line();
	while (file.get_position() < file.get_length()):
		var row := file.get_csv_line();

		if (row.size() != headers.size()):
			push_error("CsvLoader.load(...): Encountered row with unexpected number of values. Columns: {headers.size()}, This row: {row.size()}. Aborting; returning all data read before this error.");
			file.close();
			return data;

		var dictionary := {};
		for i in range(headers.size()):
			dictionary[headers[i]] = row[i];
		data.append(dictionary);

	file.close();
	return data;
