@tool
extends Node

class_name animationHandler

@export var model : Node3D
@export var animationPlayer : AnimationPlayer
@export var action : Dictionary = {}
@export var animTree: AnimationTree

func _get_tool_buttons():
	return [
		autoAnimationSetup
			]
			
func playAnimation(key : String,boolean : bool):
	updateAnimationParameter(key,boolean)
	
func autoAnimationSetup():
	for i in animationPlayer.get_animation_list():
		action[i] = i

func updateAnimationParameter(key : String,boolean : bool):
	animTree["parameters/conditions/" + key] = boolean

func setBlendValue2D(blendValue : Vector2):
	animTree["parameters/walk/blend_position"] = blendValue
