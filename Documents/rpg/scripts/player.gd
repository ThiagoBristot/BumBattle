extends CharacterBody2D
class_name Player

@export var speed: int = 120
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var state_machine: StateMachine = $StateMachine
@onready var weapon_holder: Node2D = $WeaponHolder

var inventory: Inventory
var current_weapon: Weapon

func _ready():
	setup_camera()
	setup_inventory()
	setup_state_machine()
	equip_starting_weapon()

func setup_camera():
	camera.make_current()
	camera.zoom = Vector2(3, 3)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0

func setup_inventory():
	inventory = get_node("Inventory")
	if not inventory:
		push_error("Inventory not found!")

func setup_state_machine():
	for state in state_machine.get_children():
		if state is State:
			state.player = self
			state_machine.add_state(state)
			print("Adding state: ", state.name)
	state_machine.change_state("idle")
	print("Initial state set to idle")

func equip_starting_weapon():
	var staff = Staff.new()
	equip_weapon(staff)

func equip_weapon(weapon: Weapon):
	if current_weapon:
		current_weapon.queue_free()
	
	current_weapon = weapon
	weapon_holder.add_child(weapon)

func _physics_process(delta):
	if state_machine:
		state_machine._physics_process(delta)  # Call the built-in method

func _process(delta):
	if state_machine:
		state_machine._process(delta)  # Call the built-in method
	camera.global_position = global_position
