extends Node
const VERSION = "v0.7"

## Use LogDuck.d(), .e(), or .w() for logging debug, error, or warning messages.
## Supports up to 6 arguments (or 7, if not starting with a string message).
## Ensure LogDuck is high in the autoload script order to avoid null errors.

## Show the stack frame that called the log in Debug messages.
var show_stack_frame_debug = false

## Show the entire stack frame that called the Log in Debug messages.
var show_full_stack_debug = false

## Show the stack frame that called the log in Warning messages.
var show_stack_frame_warning = true

## Show the entire stack frame that called the Log in Warning messages.
var show_full_stack_warning = false

## Show the stack frame that called the log in Error messages.
var show_stack_frame_error = true

## Show the entire stack frame that called the Log in Error messages.
var show_full_stack_error = false


## The text-prefix to be added to the beginning of Error messages
var prefix_error = "[ERROR] "
## The text-prefix to be added to the beginning of Warning messages
var prefix_warning = "[WARNING] "
## The text-prefix to be added to the beginning of Debug messages
var preface_debug = ""


## The output format of (plain) console messages
## Order of placeholders: Prefix, Class Name, Message/Argument, Extra Arguments
var console_output_format = "%s(%s) %s %s"

## The format of the stack frame line when enabled.
## Order of placeholders: Script path, line number, function
var console_format_stack_frame = "%s:%s -> %s"

## The format of the stack frame line when enabled.
## Stack is output as a single string
var console_format_full_stack = "%s"

## Show Debug messages in the console
var enable_console_debug := true

## Show warnings in the console
var enable_console_warnings := true

## Push warnings to the Godot Debugger
## (Only works in editor)
var enable_debugger_warnings := true

## Show errors in the console
var enable_console_errors := true

## Push errors to the Godot Debugger
## (Only works in editor)
var enable_errors_in_debugger := true

## Enable / disable asserts to pause the game when an error gets logged
## Note: Only works in editor or debug builds
var throw_exception_on_error := false

#var SHOW_TIME : bool = true
#var SHOW_SECONDS_AFTER_LAUNCH : bool = true

## Select, which type of seperator to use for the arguments
var seperator : SeperatorType = SeperatorType.COMMA


## Settings to customize print_rich() output. Please note, that if you remove
## a %s-placeholder, you will need to remove the arguments when formatting the string.

## Enable to customize your ouput with BBCode
var print_rich : bool = true

## Set true if you don't want to parse BB Code sent in arguments
## Can be useful for chat messages, or if you output RichLabelText content
var escape_bbcode_in_arguments : bool = true


## Format to be applied to rich console output for stack frame
var rich_console_format_stack_frame = "[i]%s:%s -> %s[/i]"

## Set true if you don't want to parse BB Code sent in arguments
## Can be useful for chat messages, or if you output RichLabelText content
var rich_console_format_full_stack = "[i]%s[/i]"

# (1) Prefix (see above) (2) Class Name
var rich_prefix_error = "[b]%s[/b] [b](%s)[/b] " # Uses prefix_error for 1st %s
var rich_msg_error = "%s"
var rich_args_error = "[i]%s[/i]"

var rich_prefix_warning = "[b]%s[/b] [b](%s)[/b] " # Uses prefix_warning for 1st %s
var rich_msg_warning = "%s"
var rich_args_warning = "[i]%s[/i]"

var rich_preface_debug = "[b]%s[/b][b](%s)[/b] " # Uses preface_debug for 1st %s
var rich_msg_debug = "%s"
var rich_args_debug = "[i]%s[/i]"

# Add BBCode tags that will apply to the entire output message
var rich_format_debug = "[color=white]%s%s %s[/color]" % [rich_preface_debug, rich_msg_debug, rich_args_debug]
var rich_format_warn = "[color=yellow]%s%s %s[/color]" % [rich_prefix_warning, rich_msg_warning, rich_args_warning]
var rich_format_error = "[color=red]%s%s %s[/color]" % [rich_prefix_error, rich_msg_error, rich_args_error]


#################################
## Only Monsters Lurking Below ##
#################################


## Used to identify the log level of the message throughout the script
enum LogLevel {
	DEBUG,
	WARN,
	ERROR,
}

enum SeperatorType {
	SPACE,
	COMMA,
	PIPE, # |
}

## The Dictionary holding holding class names with their script path as key
## Is tried to be filled automatically by LogDuck, but entries can be manually added
## [codeblock]
## class_name_dict["res://path_to_script.gd"] = "Class Name"
## [/codeblock]
var class_name_dict : Dictionary


func _enter_tree() -> void:
	class_name_dict = get_singletons()


func _ready() -> void:
	d('LogDuck %s ready to go! 🦆' % VERSION)


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


func extract_class_name_from_path(path):
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
		_class = extract_class_name_from_path(frame[0])
	
	var _message : String
	var _arguments : String
	
	var args_original : Array[Variant] = [arg1, arg2, arg3, arg4, arg5, arg6]
	
	if not msg is String:
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
	
	for arg_string in args_processed:
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
			if enable_debugger_warnings:
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

#endregion


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
	
#endregion

