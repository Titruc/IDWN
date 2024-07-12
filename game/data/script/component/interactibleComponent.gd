@icon("res://editor/assets/component/interactibleComponent.png")
extends Node3D
class_name interactibleComponent

@export var scriptToExecute : interactionScript

func interact():
	scriptToExecute.execute()
