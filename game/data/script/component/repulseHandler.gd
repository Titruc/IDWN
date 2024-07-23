extends Node3D
class_name repulseHandler

@export var area : Area3D
@export var collider : CollisionShape3D
@export var raduis : float

func _ready():
	collider.shape.radius = raduis
	
func getOtherBody():
	return area.get_overlapping_bodies()

func getRadius():
	return collider.shape.radius
