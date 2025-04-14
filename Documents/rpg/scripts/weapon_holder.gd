extends Node2D
class_name Weapon

var attack_force: float = 300.0
var attack_range: float = 50.0
var damage: int = 10

func attack():
	# Base attack logic that can be overridden by specific weapons
	var attack_direction = get_attack_direction()
	var attack_position = global_position + (attack_direction * attack_range / 2)
	
	var space_state = get_tree().get_root().get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		attack_position + (attack_direction * attack_range)
	)
	query.exclude = [owner]
	
	var result = space_state.intersect_ray(query)
	if result and result["collider"].is_in_group("enemies"):
		apply_damage_and_force(result["collider"], attack_direction)

func get_attack_direction() -> Vector2:
	var player = owner as Player
	if not player:
		return Vector2.RIGHT
		
	if player.sprite.flip_h:
		return Vector2.LEFT
	if player.sprite.animation == "walk_up":
		return Vector2.UP
	elif player.sprite.animation == "walk_down":
		return Vector2.DOWN
	return Vector2.RIGHT

func apply_damage_and_force(target: Node2D, direction: Vector2):
	if target.has_method("take_damage"):
		target.take_damage(damage)
	if target.has_method("push"):
		target.push(direction * attack_force)
