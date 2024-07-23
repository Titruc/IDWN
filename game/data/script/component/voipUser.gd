extends AudioStreamPlayer3D
class_name VoipUser

@export var offset: Vector3
@export var volume_curve: Curve

var user_id: int
var anchor: Node3D

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(anchor): return
	global_position = anchor.global_position + offset


func set_user_id(id: int) -> void:
	user_id = id


func set_anchor(_anchor: Node3D) -> void:
	anchor = _anchor


func change_volume(id: int, volume: float) -> void:
	if id != user_id: return
	volume_db = linear_to_db(volume_curve.sample(volume))
