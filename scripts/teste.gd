extends CharacterBody2D

const UP_DIRECTION := Vector2.UP
var speed = 300
var jump_strenght = -200
var gravity := 4500

var _velocity := Vector2.ZERO

func _physics_process(delta):
	var horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_right")
	)
	
	_velocity.x = horizontal_direction * speed
	_velocity.y += gravity * delta
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)



	
