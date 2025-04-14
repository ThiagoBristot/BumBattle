extends Area2D
class_name BerryBush

@export var fruit_item_id: String = "berry"
@export var fruit_quantity: int = 1
var interaction_label: Label
var player_in_range: bool = false

func _ready():
	# Connect the signals properly
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	interaction_label = $Label
	if interaction_label:
		interaction_label.text = "E"
		interaction_label.visible = false
	else:
		print("ERROR: Interaction Label not found!")

func _on_body_entered(body):
	print("Body entered: ", body.name)
	if body is Player:
		player_in_range = true
		if interaction_label:
			interaction_label.visible = true
		print("Player detected: prompt shown")

func _on_body_exited(body):
	print("Body exited: ", body.name)
	if body is Player:
		player_in_range = false
		if interaction_label:
			interaction_label.visible = false
		print("Player left: prompt hidden")

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
		print("Interact key pressed while in range!")  # Debug print
		_interact()

func _interact():
	if not player_in_range:
		return
		
	var bodies = get_overlapping_bodies()
	print("Overlapping bodies: ", bodies)  # Debug print
	
	for body in bodies:
		print("Checking body: ", body.name)  # Debug print
		if body is Player:
			print("Player found, attempting to add item")
			# Make sure the inventory exists
			if not body.has_node("Inventory"):
				push_error("Player does not have an Inventory node!")
				return
				
			var inventory = body.get_node("Inventory")
			if inventory:
				inventory.add_item(fruit_item_id, fruit_quantity, "item")
				print("+1 berry added to inventory")
				queue_free()
			else:
				push_error("Could not get inventory node!")
			break
