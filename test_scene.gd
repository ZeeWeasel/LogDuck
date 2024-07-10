@tool
extends Control
class_name TestScene

@onready var debug_msg_line_edit: LineEdit = $CenterContainer/VBoxContainer/LineEdit
@onready var check_box: CheckBox = $CenterContainer/VBoxContainer/CheckBox
@onready var checkbox_rich_output: CheckBox = $"CenterContainer/VBoxContainer/Checkbox Rich Output"

const SingletonName : String = "LogDuck"
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LogDuck.print_rich = checkbox_rich_output.button_pressed
	if Engine.is_editor_hint():
		LogDuck.d("Calling LogDuck in the editor / inside @tool script");
	else:
		LogDuck.d("Calling LogDuck during runtime");

func _on_button_debug_pressed() -> void:
	LogDuck.print_rich = checkbox_rich_output.button_pressed
	LogDuck.d(debug_msg_line_edit.text, check_box.button_pressed)


func _on_button_warning_pressed() -> void:
	LogDuck.print_rich = checkbox_rich_output.button_pressed
	LogDuck.w(debug_msg_line_edit.text, check_box.button_pressed)


func _on_button_error_pressed() -> void:
	LogDuck.print_rich = checkbox_rich_output.button_pressed
	LogDuck.e(debug_msg_line_edit.text, check_box.button_pressed)


func _on_print_specs_pressed() -> void:
	LogDuck.print_rich = checkbox_rich_output.button_pressed
	var specs = LogDuckSystemSpecs.new()
	specs.output()
