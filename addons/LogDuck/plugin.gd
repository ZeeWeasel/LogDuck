@tool
extends EditorPlugin

## Adjust the singleton name if you prefer something more classic like "Log"
const SingletonName : String = "LogDuck"

func _enter_tree():
	add_autoload_singleton(SingletonName, "res://addons/LogDuck/LogDuck.gd")
