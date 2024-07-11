@icon("res://editor/assets/component/velocityComponent.png")
extends Node
class_name velocityComponent

var Velocity : Vector3 = Vector3(0, 0, 0)

func setCurrentVelocity(velocity):
	'''
	set the Velocity to velocity
	PARAMETER velocity TYPE Vector3
	RETURN None
	'''
	Velocity = velocity

func applyGravity(gravityForce : float, delta : float):
	'''
	apply the gravity to the velocity (by default gravity have a force of 9.8)
	PARAMETER velocity TYPE vector3, gravityForce TYPE float, delta TYPE float
	RETURN None
	'''
	Velocity.y -= gravityForce * delta
	
func setVelocityX(velocityX : float):
	'''
	set Velocity.x to velocityX
	PARAMETER velocityX TYPE float
	RETURN None
	'''
	Velocity.x = velocityX

func setVelocityY(velocityY : float):
	'''
	set Velocity.y to velocityZ
	PARAMETER velocityY TYPE float
	RETURN None
	'''
	Velocity.y = velocityY

func setVelocityZ(velocityZ : float):
	'''
	set Velocity.z to velocityZ
	PARAMETER velocityZ TYPE float
	RETURN None
	'''
	Velocity.z = velocityZ

func setVelocityXZ(velocityXZ : Vector2):
	'''
	set velocity.x and velocity.z as velocityXZ[0] and velocityXZ[1] (use for movement)
	PARAMETER velocityXZ TYPE Vector2
	RETURN None
	'''
	Velocity.x = velocityXZ[0]
	Velocity.z = velocityXZ[1]

func getFinalVelocity():
	'''
	get Velocity
	PARAMETER none
	RETURN Velocity TYPE Vector3
	'''
	return Velocity
