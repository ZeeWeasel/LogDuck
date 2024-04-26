extends Node
class_name LogDuck #If you prefer a different class_name, simply adust this

enum LOG_LEVEL {
	DEBUG,
	WARN,
	ERROR
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func d(msg : String, arg1, arg2, arg3, arg4, arg5, arg6):
	if arg1 is Array:
		pass
		
	_output(LOG_LEVEL.DEBUG, msg, arg1, arg2, arg3, arg4, arg5, arg6)
	
	pass
	
func _output(level : LOG_LEVEL, msg, arg1, arg2, arg3, arg4, arg5, arg6):
	
	var final_message : String = msg + ", " + str(arg1)
	
	match level:
		LOG_LEVEL.DEBUG:
			pass
		LOG_LEVEL.WARN:
			pass
		LOG_LEVEL.ERROR:
			pass
