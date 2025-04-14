extends State
class_name AttackState

func enter():
	player.sprite.play("attack")
	if player.current_weapon:
		player.current_weapon.attack()
		player.current_weapon.rotate(30)

func physics_process_state(delta: float):  # Fixed method name
	if not player.sprite.is_playing() or player.sprite.frame >= player.sprite.sprite_frames.get_frame_count("attack") - 1:
		player.state_machine.change_state("idle")  # Match case with state name
