extends CharacterBody3D

#const for move
@export var playerAttribute : playerAttribute

#var for movement
var speed : float = 0.0
@export var isAbleToMove : bool = true

#var for juicy stuff
var bob_progress : float = 0.0
#var for other stuff
var gravity : float = 9.8

@onready var head = $head
@onready var camera = $head/playerCamera
@export var velocityHandler : velocityComponent

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	
	#head turn
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * playerAttribute.SENSITIVITY)
		camera.rotate_x(-event.relative.y * playerAttribute.SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60),deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	velocityHandler.setCurrentVelocity(velocity)
	
	if isAbleToMove:
		if not is_on_floor():
			velocityHandler.applyGravity(gravity, delta)

		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocityHandler.setVelocityY(playerAttribute.JUMP_VELOCITY)
			
		#sprint and walk
		
		#and speed and camera fov
		if Input.is_action_pressed("sprint"):
			speed = lerp(speed,playerAttribute.SPRINT_SPEED,playerAttribute.SPEED_VARIATION)
			camera.fov = lerp(camera.fov, playerAttribute.FOV+(playerAttribute.FOV_VARIATION * clamp(velocity.length(),0,1)), 0.1)
			
		else:
			speed = lerp(speed,playerAttribute.WALK_SPEED,playerAttribute.SPEED_VARIATION)
			camera.fov = lerp(camera.fov, float(playerAttribute.FOV), 0.1)
			
		#handle direction
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocityHandler.setVelocityXZ(Vector2(direction.x * speed,direction.z * speed))
		else:
			velocityHandler.setVelocityXZ(Vector2(0, 0))
		
		#head bobing
		bob_progress += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _headbob(bob_progress)
		
		velocity = velocityHandler.getFinalVelocity()
		move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(time * playerAttribute.BOB_FREQUENTY) * playerAttribute.BOB_AMPLITUDE
	pos.x = cos(time * playerAttribute.BOB_FREQUENTY/2.0) * playerAttribute.BOB_AMPLITUDE
	return pos

func _on_area_3d_area_entered(area):
	print(area)
