extends Area2D
class_name Fireball

@export var speed: float = 200.0
@export var damage: int = 20
@export var max_range: float = 500.0  # Maximum travel distance

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var direction: Vector2 = Vector2.ZERO
var start_position: Vector2
var current_state: String = "casting"
var animation_finished: bool = false

func _ready():
	start_position = global_position
	connect("body_entered", _on_body_entered)
	# Connect to animation finished signal
	sprite.animation_finished.connect(_on_animation_finished)
	play_animation("Casting")

func _physics_process(delta):
	match current_state:
		"casting":
			if animation_finished:
				animation_finished = false
				transition_to_travel()
		"travel":
			position += direction * speed * delta
			
			# Check if max range reached
			if global_position.distance_to(start_position) >= max_range:
				explode()
		"explode":
			if animation_finished:
				queue_free()

func _on_animation_finished():
	animation_finished = true

func set_damage(new_damage: int):
	damage = new_damage

func launch(new_direction: Vector2):
	direction = new_direction.normalized()
	rotation = direction.angle()

func transition_to_travel():
	current_state = "travel"
	play_animation("Travel")

func _on_body_entered(body: Node):
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
	explode()

func explode():
	current_state = "explode"
	# Disable collision and movement
	collision_shape.set_deferred("disabled", true)
	speed = 0
	play_animation("Explode")

func play_animation(anim_name: String):
	if sprite:
		sprite.play(anim_name)
