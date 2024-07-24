@icon("res://editor/assets/component/repulseHandler.png")
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


func repulse(body,thisBody):
	var vector : Vector3 = (body.position - thisBody.position) * -1
	var vectorToVector2 : Vector2 = Vector2(vector.x, vector.z)
	var repulseForce : float = (self.getRadius() - vectorToVector2.length()) + 1
	return vectorToVector2.normalized() * repulseForce * 1.5
