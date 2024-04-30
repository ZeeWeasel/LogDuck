extends LogDuckSettings
const VERSION = "v0.8.0"

## Use LogDuck.d(), .e(), or .w() for logging debug, error, or warning messages.
## Supports up to 6 arguments (or 7, if not starting with a string message).
## Ensure LogDuck is high in the autoload script order to avoid null errors.

###########################################
## Adjust Settings in LogDuckSettings.gd ##
###########################################


## The Dictionary holding holding class names with their script path as key
## Is tried to be filled automatically by LogDuck, but entries can be manually 
## added in the ready() function or called from the script itself
## [codeblock]
## class_name_dict["res://path_to_script.gd"] = "Class Name"
## [/codeblock]
var class_name_dict : Dictionary

func _enter_tree() -> void:
	# We are trying to fill the name dictionary as early as possible
	class_name_dict = get_singletons()

func _ready() -> void:
	if show_instance_number:
		get_instance_number()
		
	if verbose: d('LogDuck %s ready to go! 🦆' % VERSION)


func d(msg, arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null):
	_output(LogLevel.DEBUG, msg, arg1, arg2, arg3, arg4, arg5, arg6)


func e(msg, arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null, will_assert = false):
	_output(LogLevel.ERROR, msg, arg1, arg2, arg3, arg4, arg5, arg6)
	if not will_assert and throw_exception_on_error:
		assert(false, str(msg))


func e_assert(msg, arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null):
	e(msg, arg1, arg2, arg3, arg4, arg5, arg6, true) # Informing that assert will happen
	assert(false, str(msg))


func w(msg, arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null):
	_output(LogLevel.WARN, msg, arg1, arg2, arg3, arg4, arg5, arg6)


## Converts an array into an array filled with strings for the console
## If you want to adjust how specific classes / variants are displayed, you can
## adjust their output string in here
## [codeblock]
## if argument is String:
##     arg_string = argument
## elif argument is Vector3:
##     arg_string = str("x:%s, y:%s, z:%s" %s [argument.x, argument.y, argument.z]
## [/codeblock]
func array_to_strings(argument_array: Array) -> Array[String]:
	var string_array: Array[String] = []
	var arg_string : String = ""
	
	for argument in argument_array:
		if argument is String:
			arg_string = argument
		#elif argument is Vector3:
		#	arg_string = str("x:%s, y:%s, z:%s" %s [argument.x, argument.y, argument.z]		
		else:
			arg_string = argument_to_string(argument)
			
		string_array.append(arg_string)
	
	return string_array


func stack_frame(index : int = 3) -> Dictionary:
	return get_stack()[index]


func argument_to_string(arg) -> String:
	if escape_bbcode_in_arguments: 
		return escape_bbcode(str(arg))
	else:
		return str(arg)


func extract_class_name_from_gdscript(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var _class : String
	if file:
		var extending : String
		var line_num = 0
		while !file.eof_reached():
			line_num += 1
			var line = file.get_line()
			
			if line.begins_with("extends"):
				extending = line.split(" ")[1].strip_edges()
				
			if line.begins_with("class_name"):
				_class = line.split(" ")[1].strip_edges()
				break
			else:
				_class = ""
				
			if _class == "":
				_class = extending
				
			if line_num > 40: # If we haven't found the entry by line 40, we stop.
				break
		file.close()
	else:
		_class = "Failed to open file"
	class_name_dict[path] = _class
	return _class


func _output(level : LogLevel, msg, arg1, arg2, arg3, arg4, arg5, arg6):
	
	var frame : Array = [
			str(stack_frame()['source']),
			str(stack_frame()['line']),
			str(stack_frame()['function'])]
			
	var _class : String
			
	if class_name_dict.has(frame[0]):
		_class = class_name_dict[frame[0]]
	else:
		# Check if script is .cs or .gd
		_class = extract_class_name_from_gdscript(frame[0])
	
	var _message : String
	var _arguments : String
	
	var args_original : Array[Variant] = [arg1, arg2, arg3, arg4, arg5, arg6]
	
	if msg is not String:
		args_original.push_front(msg)
	else:
		_message += msg
	
	var args_processed : Array[String]
	
	for arg in args_original:
		if arg:
			if arg is Array:
				args_processed.append_array(array_to_strings(arg))
			else:
				args_processed.append(argument_to_string(arg))
	
	var seperator : String
	
	match seperator:
		SeperatorType.SPACE:
			seperator = " "
		SeperatorType.COMMA:
			seperator = ", "
		SeperatorType.PIPE:
			seperator = " | "
	
	for arg_string : String in args_processed:
		_arguments += seperator + arg_string
	
	var msg_plain 
	var msg_rich
	
	var _prefix
	
	match level:
		LogLevel.ERROR:
			_prefix = prefix_error
			msg_rich = rich_format_error % [_prefix, _class, _message, _arguments]
		LogLevel.WARN:
			_prefix = prefix_warning
			msg_rich = rich_format_warn % [_prefix, _class, _message, _arguments]
		LogLevel.DEBUG:
			_prefix = preface_debug
			msg_rich = rich_format_debug % [_prefix, _class, _message, _arguments]
	
	msg_plain = console_output_format % [_prefix, _class, _message, _arguments]
	
	var full_stack_plain : String
	var full_stack_rich : String
	
	if show_full_stack_debug or show_full_stack_warning or show_full_stack_error:
		full_stack_plain = console_format_full_stack % str(get_stack())
		full_stack_rich = rich_console_format_full_stack % str(get_stack())
		
	var stack_frame_plain : String
	var stack_frame_rich : String
	
	if show_stack_frame_debug or show_stack_frame_warning or show_stack_frame_error:
		stack_frame_plain = console_format_stack_frame % [frame[0],frame[1],frame[2]]
		stack_frame_rich = rich_console_format_stack_frame % [frame[0],frame[1],frame[2]]
		
	# Instance
		
	if show_instance_number and _instance_num>-1:
		
		var color_instance : String
		
		if _instance_num < instance_number_rich_colors.size():
			color_instance = instance_number_rich_colors[_instance_num]
		else:
			color_instance = instance_number_rich_colors[5]
		
		var instance_string_plain = instance_number_format_plain % str(_instance_num)
		var instance_string_rich = instance_number_format_rich % [color_instance, str(_instance_num)]
		
		msg_plain = instance_string_plain + msg_plain
		msg_rich = instance_string_rich + msg_rich


	output_messages(level, msg_plain, msg_rich, full_stack_rich, stack_frame_rich, full_stack_plain, stack_frame_plain)


func output_messages(level, msg_plain, msg_rich, full_stack_rich, stack_frame_rich, full_stack_plain, stack_frame_plain) -> void:
	match level:
		LogLevel.ERROR:
			if enable_errors_in_debugger:
				if OS.has_feature("editor"):
					push_error(msg_plain)
			if enable_console_errors:
				if print_rich:
					print_rich(msg_rich)
					if show_full_stack_error:
						print_rich(full_stack_rich)
					elif show_stack_frame_error:
						print_rich(stack_frame_rich)
				else:
					printerr(msg_plain)
					if show_full_stack_error:
						print(full_stack_plain)
					elif show_stack_frame_error:
						print(stack_frame_plain)
					
		LogLevel.WARN:
			if enable_warnings_in_debugger:
				if OS.has_feature("editor"):
					push_warning(msg_plain)
			if enable_console_warnings:
				if print_rich:
					print_rich(msg_rich)
					if show_full_stack_warning:
						print_rich(full_stack_rich)
					elif show_stack_frame_warning:
						print_rich(stack_frame_rich)
				else:
					print(msg_plain)
					if show_full_stack_warning:
						print(full_stack_plain)
					elif show_stack_frame_warning:
						print(stack_frame_plain)
		LogLevel.DEBUG:
			if enable_console_debug:
				if print_rich:
					print_rich(msg_rich)	
					if show_full_stack_debug:
						print_rich(full_stack_rich)
					elif show_stack_frame_debug:
						print_rich(stack_frame_rich)
				else:
					print(msg_plain)
					if show_full_stack_debug:
						print(full_stack_plain)
					elif show_stack_frame_debug:
						print(stack_frame_plain)


## Call to overwrite / set a custom identifier for the output name
func register_class_name(_class_name : String) -> void:
	var path = stack_frame(2)['source']
	if verbose: d("Registering class '%s' with path %s" % [path, _class_name])
	class_name_dict[path] = _class_name


#region Helper Functions

## Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
func escape_bbcode(_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return _text.replace("[", "[lb]")


func remove_bbcode(_text):
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(_text, "", true)
	return text_without_tags


# Thanks to me2beats https://github.com/godotengine/godot-proposals/issues/3705
static func get_singletons() -> Dictionary:
	var singletons: = {}
	var config: = ConfigFile.new()
	var err: = config.load("project.godot")
	if err:
		push_error("Error when loading project.godot")
		return singletons

	var autoload: = "autoload"
	if not config.has_section(autoload): return singletons

	for val in config.get_section_keys(autoload):
		var key:String = config.get_value(autoload, val)
		key = key.trim_prefix("*")
		# If an singleton is a scene instead of a gdscript,
		# we replace the file ending, to possibly catch the
		# GDScript running on that Singleton
		key = key.replace(".tscn", ".gd")
		singletons[key] = val
		
	return singletons


var _instance_num := -1
var _instance_socket: TCPServer 

# Thanks to https://gist.github.com/CrankyBunny/71316e7af809d7d4cf5ec6e2369a30b9
func get_instance_number():
	if OS.is_debug_build():
		_instance_socket = TCPServer.new()
		for n in range(0,4):
			if _instance_socket.listen(5000 + n) == OK:
				_instance_num = n
				break

		if _instance_num < 0:
			LogDuck.e("Unable to determine instance number. Seems like all TCP ports are in use")
			return
			
		LogDuck.d("We are instance number ", _instance_num+1)
		

#endregion

