@tool
extends Node

class_name animationHandler

@export var model : Node3D
@export var animationPlayer : AnimationPlayer
@export var action : Dictionary = {}

func _get_tool_buttons():
	return [
		autoAnimationSetup
			]
			
func playAnimation(key : String):
	animationPlayer.play(action[key])

func autoAnimationSetup():
	for i in animationPlayer.get_animation_list():
		action[i] = i
