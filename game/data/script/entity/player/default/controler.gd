extends CharacterBody3D

# Constants for movement
@export var playerAttribute : playerAttribute

# Variables for movement
var speed : float = 0.0
@export var isAbleToMove : bool = true

# Variables for juicy stuff
var bob_progress : float = 0.0

@onready var head = $head
@onready var camera : Camera3D = $head/playerCamera
@export var velocityHandler : velocityComponent
@export var inputhandler : inputHandler

func _ready():
	set_multiplayer_authority(name.to_int())
	inputhandler.set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.make_current()
	$RollbackSynchronizer.process_settings()

func _unhandled_input(event):
	if is_multiplayer_authority():
		handle_mouse_motion(event)

func handle_mouse_motion(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * playerAttribute.SENSITIVITY)
		camera.rotate_x(-event.relative.y * playerAttribute.SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _rollback_tick(delta, tick, is_fresh):
	if is_multiplayer_authority():
		handle_host_movement(delta)
	else:
		handle_client_movement(delta)

func handle_host_movement(delta):
	_force_update_is_on_floor()
	velocityHandler.setCurrentVelocity(velocity)
	
	if isAbleToMove:
		if not is_on_floor():
			velocityHandler.applyGravity(playerAttribute.GRAVITY, delta)

		# Handle Jump.
		if inputhandler.asJump and is_on_floor():
			velocityHandler.setVelocityY(playerAttribute.JUMP_VELOCITY)
			
		# Update speed
		speed = lerp(speed, 
					 playerAttribute.SPRINT_SPEED if inputhandler.isSprinting else playerAttribute.WALK_SPEED, 
					 playerAttribute.SPEED_VARIATION)

		var input_dir = inputhandler.direction
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocityHandler.setVelocityXZ(Vector2(direction.x * speed, direction.z * speed))
		else:
			velocityHandler.setVelocityXZ(Vector2(0, 0))
		
		velocity = velocityHandler.getFinalVelocity()
		velocity *= NetworkTime.physics_factor
		move_and_slide()
		velocity /= NetworkTime.physics_factor

func handle_client_movement(delta):
	# Handle client movement based on network data
	pass

func _force_update_is_on_floor():
	var old_velocity = velocity
	velocity = Vector3.ZERO
	move_and_slide()
	velocity = old_velocity

func _process(delta):
	if is_multiplayer_authority():
		update_camera_fov(delta)
		update_head_bobbing(delta)

func update_camera_fov(delta):
	if inputhandler.isSprinting:
		camera.fov = lerp(camera.fov, playerAttribute.FOV + (playerAttribute.FOV_VARIATION * clamp(velocity.length(), 0, 1)), 0.1 * delta)
	else:
		camera.fov = lerp(camera.fov, float(playerAttribute.FOV), 0.1 * delta)

func update_head_bobbing(delta):
	bob_progress += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(bob_progress)

func _headbob(time) -> Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = sin(time * playerAttribute.BOB_FREQUENTY) * playerAttribute.BOB_AMPLITUDE
	pos.x = cos(time * playerAttribute.BOB_FREQUENTY / 2.0) * playerAttribute.BOB_AMPLITUDE
	return pos
