@icon("res://editor/assets/component/inputHandler.png")
extends Node
class_name inputHandler

@export var asJump : bool = false
@export var isSprinting : bool = false
@export var direction : Vector2 = Vector2(0, 0)
@export var leftClick : bool = false

func _ready():
	NetworkTime.before_tick_loop.connect(_gather)

func _gather():
	if Input.is_action_just_pressed("jump"):
		print("jump netwotk : " , Input.is_action_just_pressed("jump"))
	if not is_multiplayer_authority():
		return
	if get_parent().name != "1":
		asJump = Input.is_action_just_pressed("jump")
		isSprinting = Input.is_action_pressed("sprint")
		direction = Input.get_vector("left", "right", "up", "down")
		leftClick = Input.is_action_just_pressed("left_click")
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		print("jump : " , Input.is_action_just_pressed("jump"), asJump)
	if not is_multiplayer_authority():
		return
	if get_parent().name == "1":
		asJump = Input.is_action_just_pressed("jump")
		isSprinting = Input.is_action_pressed("sprint")
		direction = Input.get_vector("left", "right", "up", "down")
		leftClick = Input.is_action_just_pressed("left_click")
	
