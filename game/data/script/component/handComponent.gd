@icon("res://editor/assets/component/handComponent.png")
extends Node3D
class_name handComponent

@onready var hand : RayCast3D = $hand
@export var handLenght : Vector3

func _ready():
	hand.target_position = handLenght * -1
	
func isInteractible(collider : Node):
	return has_child_of_type(collider)

func getInteraction():
	return hand.get_collider().get_parent()

func has_child_of_type(parent_node: Node):
	for child in parent_node.get_children():
		if child.script != null:
			if child.get_script().resource_path == "res://game/data/script/component/interactibleComponent.gd":
				return child
	return false
	
func interact():
	var interactible = getInteraction()
	if interactible:
		if isInteractible(interactible):
			isInteractible(interactible).interact()

func isColliding():
	return hand.is_colliding()
	
