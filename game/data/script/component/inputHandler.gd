@icon("res://editor/assets/component/inputHandler.png")
extends Node
class_name inputHandler

@export var asJump : bool = false
@export var isSprinting : bool = false
@export var direction : Vector2 = Vector2(0, 0)

func _ready():
	NetworkTime.before_tick_loop.connect(_gather)

func _gather():
	if not is_multiplayer_authority():
		return
	asJump = Input.is_action_just_pressed("jump")
	isSprinting = Input.is_action_pressed("sprint")
	direction = Input.get_vector("left", "right", "up", "down")

	
