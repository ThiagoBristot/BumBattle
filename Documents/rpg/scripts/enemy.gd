extends CharacterBody2D
class_name Enemy

enum EnemyState { IDLE, CHASE, DIE }  # Renamed enum

@export var max_health: float = 20.0
@export var friction: float = 0.1
@export var chase_speed: float = 100.0
@export var detection_range: float = 200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

var current_health: float
var external_force: Vector2 = Vector2.ZERO
var current_state = EnemyState.IDLE  # Updated to use EnemyState
var animation_finished: bool = false

func _ready():
	current_health = max_health
	add_to_group("enemies")
	if sprite:
		sprite.animation_finished.connect(_on_animation_finished)
		play_animation("idle")

func _physics_process(delta):
	match current_state:
		EnemyState.IDLE:  # Updated
			handle_idle_state()
		EnemyState.CHASE:  # Updated
			handle_chase_state(delta)
		EnemyState.DIE:  # Updated
			handle_die_state()
	
	if external_force.length() > 0:
		external_force = external_force.lerp(Vector2.ZERO, friction)
		velocity = external_force
		move_and_slide()

func handle_idle_state():
	if player and position.distance_to(player.position) <= detection_range:
		change_state(EnemyState.CHASE)  # Updated

func handle_chase_state(delta: float):
	if not player:
		change_state(EnemyState.IDLE)  # Updated
		return
		
	var direction = (player.position - position).normalized()
	velocity = direction * chase_speed
	
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
		
	if external_force.length() < 0.1:
		move_and_slide()
	
	if position.distance_to(player.position) > detection_range:
		change_state(EnemyState.IDLE)  # Updated

func handle_die_state():
	if animation_finished:
		queue_free()

func take_damage(amount: float):
	current_health -= amount
	if sprite:
		sprite.modulate = Color(1, 0.3, 0.3)
		get_tree().create_timer(0.1).timeout.connect(func(): sprite.modulate = Color.WHITE)
	if current_health <= 0:
		change_state(EnemyState.DIE)  # Updated

func push(force: Vector2):
	external_force = force

func die():
	change_state(EnemyState.DIE)  # Updated

func change_state(new_state: EnemyState):  # Parameter type updated
	if current_state == new_state:
		return
	current_state = new_state
	animation_finished = false
	match new_state:
		EnemyState.IDLE:  # Updated
			play_animation("idle")
		EnemyState.CHASE:  # Updated
			play_animation("chase")
		EnemyState.DIE:  # Updated
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			play_animation("die")

func play_animation(anim_name: String):
	if sprite:
		sprite.play(anim_name)

func _on_animation_finished():
	animation_finished = true
