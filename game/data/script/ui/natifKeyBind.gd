extends Node

func _process(delta):
	#handle windows mode switch : fullscreen/windowed
	if Input.is_action_just_pressed("screenMode"):
		if(DisplayServer.window_get_mode() == 0):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif(DisplayServer.window_get_mode() == 3):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
