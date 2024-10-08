extends CharacterBody3D


#const for move
@export var playerAttributeVar : playerAttribute
@export var playerName : String = ""

#var for movement
var speed : float = 0.0
@export var isAbleToMove : bool = true

#var for juicy stuff
var bob_progress : float = 0.0
var dirForAnim : Vector2 = Vector2(0,0)


@onready var head = $head
@onready var camera : Camera3D = $head/playerCamera
@export var velocityHandler : velocityComponent
@export var inputhandler : inputHandler
@export var isOnFloor : isOneFloorComponent
@export var hand : handComponent
@export var voiceManager : Node
@export var animationHandler : animationHandler
@export var model : Node3D
@export var repulseHandler : repulseHandler
@export var nameLabel : Label3D


func _ready():
	
	set_multiplayer_authority(name.to_int())
	inputhandler.set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		setName()
		model.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.make_current()
		voiceChatSetup(name.to_int())
	$RollbackSynchronizer.process_settings()
	
	
func _unhandled_input(event):
	
	#head turn
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * playerAttributeVar.SENSITIVITY)
		camera.rotate_x(-event.relative.y * playerAttributeVar.SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60),deg_to_rad(60))

func _rollback_tick(delta, _tick, _is_fresh):
	if is_multiplayer_authority():
		_force_update_is_on_floor()
		velocityHandler.setCurrentVelocity(velocity)

		if isAbleToMove:
			_force_update_is_on_floor()
			if not isOnFloor.isOnFloorImprove():
				velocityHandler.applyGravity(playerAttributeVar.GRAVITY, delta)
			_force_update_is_on_floor()
			# Handle Jump.
			if inputhandler.asJump :
				if isOnFloor.isOnFloorImprove():
					velocityHandler.setVelocityY(playerAttributeVar.JUMP_VELOCITY)

			# Update speed
			var currentSpeed : float
			speed = lerp(speed, 
						speedVariation(),
						playerAttributeVar.SPEED_VARIATION)
			var input_dir = inputhandler.direction
			var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

			if direction:
				velocityHandler.setVelocityXZ(Vector2(direction.x * speed, direction.z * speed))
			else:
				velocityHandler.setVelocityXZ(Vector2(0, 0))
			
			dirForAnim = Vector2(lerp(dirForAnim.x, input_dir.x + int(inputhandler.isSprinting) * input_dir.x, 0.3),lerp(dirForAnim.y, input_dir.y + int(inputhandler.isSprinting) * input_dir.y, 0.3))
			animationHandler.setBlendValue2D(dirForAnim)
			
			for body in repulseHandler.getOtherBody():
				velocityHandler.addVelocityXZ(repulseHandler.repulse(body,self))
	
			
	velocity = velocityHandler.getFinalVelocity()
	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
		
func speedVariation():
	var speed : float 
	if inputhandler.isSprinting :
		speed = playerAttributeVar.SPRINT_SPEED
	elif inputhandler.isCrouch :
		speed = playerAttributeVar.CROUCH_SPEED
	else :
		speed = playerAttributeVar.WALK_SPEED
	return speed 
			
func _force_update_is_on_floor():
	var old_velocity = velocity
	velocity = Vector3.ZERO
	move_and_slide()
	velocity = old_velocity

func voiceChatSetup(id):
	pass
	#voiceManager.id_autority = id
	#voiceManager.setupAudio(id)
	
func _process(delta):
	# Add the gravity.
	if is_multiplayer_authority():
		
	
			#and speed and camera fov
			if inputhandler.isSprinting:
				camera.fov = lerp(camera.fov, playerAttributeVar.FOV+(playerAttributeVar.FOV_VARIATION * clamp(velocity.length(),0,1)), 0.1)
			else:
				camera.fov = lerp(camera.fov, float(playerAttributeVar.FOV), 0.1)
				
			#handle direction
			#head bobing
			bob_progress += delta * velocity.length() * float(isOnFloor.isOnFloorImprove())
			camera.transform.origin = _headbob(bob_progress)
			
			if inputhandler.leftClick:
				interact()
			model.rotation = (head.rotation - Vector3(0,PI,0))
			
	
func _headbob(time) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(time * playerAttributeVar.BOB_FREQUENTY) * playerAttributeVar.BOB_AMPLITUDE
	pos.x = cos(time * playerAttributeVar.BOB_FREQUENTY/2.0) * playerAttributeVar.BOB_AMPLITUDE
	return pos

func interact():
	hand.interact()

func setName():
	nameLabel.hide()
	playerName = GameManager.playerData[multiplayer.get_unique_id()]["name"]
	if playerName == "":
		playerName = "Player " + self.name
	nameLabel.text = playerName
	MKUtil.print("you are now : " + playerName)
