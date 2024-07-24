@icon("res://editor/assets/component/isOnFloorComponent.png")
extends Node3D
class_name isOneFloorComponent

@export var NodeToCheck : Node
@export var lenght : float
@onready var raycast : RayCast3D = $floorDetection

func _ready():
	raycast.target_position.y = lenght * -1.0
	
func isOnFloorImprove():
	return NodeToCheck.is_on_floor() or raycast.is_colliding()
	

