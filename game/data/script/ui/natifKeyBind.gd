extends Node

@export var escape_menu : Node2D

func _process(_delta):
	#handle windows mode switch : fullscreen/windowed
	if Input.is_action_just_pressed("screenMode"):
		if(DisplayServer.window_get_mode() == 0):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif(DisplayServer.window_get_mode() == 3):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
	if Input.is_action_just_pressed("escape"):
		if escape_menu.visible == true:
			escape_menu.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			escape_menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_close_game_pressed():
	var multiplayerControler = self.get_parent().find_child("multiplayerControler")
	multiplayerControler.close_upnp(multiplayerControler.upnp, 9999)
