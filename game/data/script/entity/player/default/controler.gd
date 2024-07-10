extends CharacterBody3D

#const for move
const WALK_SPEED : float = 5.0
const SPRINT_SPEED : float = 7.5
const JUMP_VELOCITY : float = 4.5
const SENSITIVITY : float = 0.005
const FOV : int = 75
const FOV_VARIATION : float = 20.0

#const for bobing head
const BOB_FREQUENTY : float = 2.0
const BOB_AMPLITUDE : float = 0.06

#var for movement
var speed : float = 0.0
@export var isAbleToMove : bool = true

#var for juicy stuff
var bob_progress : float = 0.0

#var for other stuff
var gravity : float = 9.8

@onready var head = $head
@onready var camera = $head/playerCamera
#@onready var hand = $head/playerCamera/hand#

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60),deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if isAbleToMove:
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		#sprint and walk
		
		#and speed and camera fov
		if Input.is_action_pressed("sprint"):
			speed = lerp(speed,SPRINT_SPEED,0.1)
			camera.fov = lerp(camera.fov, FOV+(FOV_VARIATION * clamp(velocity.length(),0,1)), 0.1)
			
		else:
			speed = lerp(speed,WALK_SPEED,0.1)
			camera.fov = lerp(camera.fov, float(FOV), 0.1)
			
		#handle direction
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
		if(not is_on_floor()):
			velocity.x = lerp(velocity.x, direction.x * speed,delta*2.0)
			velocity.y = lerp(velocity.y, direction.y * speed,delta*2.0)
		#head bobing
		bob_progress += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _headbob(bob_progress)
		move_and_slide()
	
	#handle interaction/interoperate object 
	#if Input.is_action_just_pressed("right_click"):
		#if hand.is_colliding():
			#var collision = hand.get_collider()
			#if collision.get_parent().has_method("interactableObject"):
				#collision.get_parent().interactableObject(self)
	#if Input.is_action_just_pressed("left_click"):
		#if hand.is_colliding():
			#var collision = hand.get_collider()
			#if collision.get_parent().has_method("interoperateObject"):
				#collision.get_parent().interoperateObject(self)
					
	


func _headbob(time) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENTY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENTY/2.0) * BOB_AMPLITUDE
	return pos

func _on_area_3d_area_entered(area):
	print(area)
