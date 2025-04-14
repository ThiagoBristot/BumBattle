extends Weapon
class_name Staff

const FIREBALL = preload("res://scenes/fire_ball.tscn")
@export var cast_point_offset: Vector2 = Vector2(20, 0)
@export var fireball_speed: float = 400.0
@export var cast_time: float = 0.5  # Time to cast in seconds

var is_casting: bool = false
var cast_timer: float = 0.0

func _init():
	attack_force = 0
	attack_range = 250.0
	damage = 10

func _process(delta):
	if is_casting:
		cast_timer += delta
		if cast_timer >= cast_time:
			complete_cast()

func attack():
	if not is_casting:
		start_cast()

func start_cast():
	is_casting = true
	cast_timer = 0.0
	# Here you might want to trigger a casting animation on the player/staff
	# player.play_animation("cast_start")

func complete_cast():
	is_casting = false
	cast_timer = 0.0
	
	var attack_direction = (get_global_mouse_position() - global_position).normalized()
	var fireball_instance = FIREBALL.instantiate() as Fireball
	
	if fireball_instance:
		var cast_point = global_position + (cast_point_offset * attack_direction)
		get_tree().current_scene.add_child(fireball_instance)
		fireball_instance.global_position = cast_point
		fireball_instance.damage = damage
		fireball_instance.speed = fireball_speed
		fireball_instance.launch(attack_direction)
