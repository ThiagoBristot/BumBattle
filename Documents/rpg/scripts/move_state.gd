extends State
class_name MoveState

func physics_process_state(delta: float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.velocity = direction * player.speed
	
	if direction != Vector2.ZERO:
		if direction.x != 0:
			player.sprite.flip_h = direction.x < 0
			player.sprite.play("walk_sideways")
		elif direction.y < 0:
			player.sprite.play("walk_up")
		elif direction.y > 0:
			player.sprite.play("walk_down")
	else:
		player.state_machine.change_state("idlestate")  # Changed from "idle"
		
	if Input.is_action_just_pressed("ui_attack"):
		player.state_machine.change_state("attackstate")  # Changed from "attack"
	
	player.move_and_slide()
