extends Control
class_name TestScene

@onready var debug_msg_line_edit: LineEdit = $CenterContainer/VBoxContainer/LineEdit
@onready var check_box: CheckBox = $CenterContainer/VBoxContainer/CheckBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_debug_pressed() -> void:
	LogDuck.d(debug_msg_line_edit.text, check_box.button_pressed)


func _on_button_warning_pressed() -> void:
	LogDuck.w(debug_msg_line_edit.text, check_box.button_pressed)


func _on_button_error_pressed() -> void:
	LogDuck.e(debug_msg_line_edit.text, check_box.button_pressed)
