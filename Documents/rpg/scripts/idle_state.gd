extends State
class_name IdleState

func enter():
	if player == null:
		push_error("Player is null in IdleState")
		return
	if player.sprite == null:
		push_error("Sprite is null in IdleState")
		return
	player.sprite.play("idle")

func physics_process_state(delta: float):
	if player == null:
		return
	if player.sprite == null:
		return
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		player.state_machine.change_state("movestate")
	elif Input.is_action_just_pressed("ui_attack"):
		player.state_machine.change_state("attackstate")
