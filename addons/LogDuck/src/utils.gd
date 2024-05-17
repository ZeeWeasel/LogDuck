extends Node
class_name LogDuckUtils


## Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
static func escape_bbcode(_text) -> String:
	# We only need to replace opening brackets to prevent tags from being parsed.
	return _text.replace("[", "[lb]")


static func remove_bbcode(_text) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(_text, "", true)
	return text_without_tags


# Thanks to me2beats https://github.com/godotengine/godot-proposals/issues/3705
static func get_singletons() -> Dictionary:
	var singletons := {}
	var config := ConfigFile.new()
	var err := config.load("project.godot")
	if err:
		push_error("Error when loading project.godot")
		return singletons

	var autoload := "autoload"
	if not config.has_section(autoload):
		return singletons

	for val in config.get_section_keys(autoload):
		var key: String = config.get_value(autoload, val)
		key = key.trim_prefix("*")
		# If an singleton is a scene instead of a gdscript,
		# we replace the file ending, to possibly catch the
		# GDScript running on that Singleton
		key = key.replace(".tscn", ".gd")
		singletons[key] = val

	return singletons


# Returns a human-readable string from a date and time, date, or time dictionary.
static func datetime_to_string(date):
	if (
		date.has("year")
		and date.has("month")
		and date.has("day")
		and date.has("hour")
		and date.has("minute")
		and date.has("second")
	):
		# Date and time.
		return "{year}-{month}-{day} {hour}:{minute}:{second}".format({
			year = str(date.year).pad_zeros(2),
			month = str(date.month).pad_zeros(2),
			day = str(date.day).pad_zeros(2),
			hour = str(date.hour).pad_zeros(2),
			minute = str(date.minute).pad_zeros(2),
			second = str(date.second).pad_zeros(2),
		})
	elif date.has("year") and date.has("month") and date.has("day"):
		# Date only.
		return "{year}-{month}-{day}".format({
			year = str(date.year).pad_zeros(2),
			month = str(date.month).pad_zeros(2),
			day = str(date.day).pad_zeros(2),
		})
	else:
		# Time only.
		return "{hour}:{minute}:{second}".format({
			hour = str(date.hour).pad_zeros(2),
			minute = str(date.minute).pad_zeros(2),
			second = str(date.second).pad_zeros(2),
		})
	
