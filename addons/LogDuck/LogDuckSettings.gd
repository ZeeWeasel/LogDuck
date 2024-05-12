extends Node
class_name LogDuckSettings

## Use LogDuck.d(), .e(), or .w() for logging debug, error, or warning messages.
## Supports up to 6 arguments (or 7, if not starting with a string message).
## Ensure LogDuck is high in the autoload script order to avoid null errors.

## Show the stack frame that called the log in Debug messages.
var show_stack_frame_debug = false

## Show the entire stack frame that called the Log in Debug messages.
var show_full_stack_debug = false

## Show the last stack frame that called the log in Warning messages.
var show_stack_frame_warning = false

## Show the entire stack frame that called the Log in Warning messages.
var show_full_stack_warning = false

## Show the last stack frame that called the log in Error messages.
var show_stack_frame_error = false

## Show the entire stack frame that called the Log in Error messages.
## Note: If 
var show_full_stack_error = false


## The text-prefix to be added to the beginning of Error messages
var prefix_error = "[ERROR]"
## The text-prefix to be added to the beginning of Warning messages
var prefix_warning = "[WARNING]"
## The text-prefix to be added to the beginning of Debug messages
var prefix_debug = ""


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
var enable_warnings_in_debugger := true

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

## Select, which type of separator to use for the arguments
var separator_type : SeparatorType = SeparatorType.PIPE



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

var rich_prefix_debug = "[b]%s[/b][b](%s)[/b] " # Uses preface_debug for 1st %s
var rich_msg_debug = "%s"
var rich_args_debug = "[i]%s[/i]"

# Add BBCode tags that will apply to the entire output message
var rich_format_debug = "[color=white]%s%s%s[/color]" % [rich_prefix_debug, rich_msg_debug, rich_args_debug]
var rich_format_warn = "[color=yellow]%s%s%s[/color]" % [rich_prefix_warning, rich_msg_warning, rich_args_warning]
var rich_format_error = "[color=red]%s%s%s[/color]" % [rich_prefix_error, rich_msg_error, rich_args_error]

## Outputs some of the internal workings into the log
var verbose := true


## Print an instance number at the start of the debug messages? 
## This is particularly handy when you are testing multiplayer and have multiple
## instances print debug information into the output
var show_instance_number : bool = false

var instance_number_format_plain = "[%s] "
var instance_number_format_rich = "[color=%s][%s][/color] "

## Colors for the instance number, last entry for any instance larger than 4
var instance_number_rich_colors : Array[String] = ["#4287f5", "#25d911", "#e6a210", "#10e6df", "#ffffff"]


####################################
## Nothing to set below this line ##
####################################

## Used to identify the log level of the message throughout the script
enum LogLevel {
	DEBUG,
	WARN,
	ERROR,
}

enum SeparatorType {
	SPACE,
	COMMA,
	PIPE, # |
}
