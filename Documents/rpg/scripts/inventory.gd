extends PanelContainer
class_name Inventory

@onready var grid_items: GridContainer = $NinePatchRect/GridContainer_Items
@onready var grid_potions: GridContainer = $NinePatchRect/GridContainer_Potions
@onready var grid_jewelry: GridContainer = $NinePatchRect/GridContainer_Jewelry
@onready var grid_armor: GridContainer = $NinePatchRect/GridContainer_Armor
@onready var grid_weapons: GridContainer = $NinePatchRect/GridContainer_Weapons
@onready var player: Player = get_parent()

@export var item_slot_scene: PackedScene = preload("res://scenes/itemslot.tscn")
@export var potion_slot_scene: PackedScene = preload("res://scenes/potionslot.tscn")
@export var jewelry_slot_scene: PackedScene = preload("res://scenes/jewelryslot.tscn")
@export var armor_slot_scene: PackedScene = preload("res://scenes/armorslot.tscn")
@export var weapon_slot_scene: PackedScene = preload("res://scenes/weaponslot.tscn")

var slots_per_category = {
	"item": 16,
	"potion": 2,
	"jewelry": 4,
	"armor": 3,
	"weapon": 2
}

func _ready():
	visible = false
	self_modulate.a = 0.9
	initialize_slots()
	# Debug print to verify grids
	print("Grid Items path: ", grid_items)
	print("Grid Potions path: ", grid_potions)
	print("Grid Jewelry path: ", grid_jewelry)
	print("Grid Armor path: ", grid_armor)
	print("Grid Weapons path: ", grid_weapons)

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		print("Inventory toggled!")
		visible = !visible

func initialize_slots():

	# Clear existing slots first
	for grid in [grid_items, grid_potions, grid_jewelry, grid_armor, grid_weapons]:
		if grid:
			for child in grid.get_children():
				child.queue_free()
				
	# Create new slots
	create_slots(grid_items, item_slot_scene, "item", slots_per_category["item"])
	create_slots(grid_potions, potion_slot_scene, "potion", slots_per_category["potion"])
	create_slots(grid_jewelry, jewelry_slot_scene, "jewelry", slots_per_category["jewelry"])
	create_slots(grid_armor, armor_slot_scene, "armor", slots_per_category["armor"])
	create_slots(grid_weapons, weapon_slot_scene, "weapon", slots_per_category["weapon"])

func create_slots(grid: GridContainer, scene: PackedScene, category: String, quantity: int):
	if not grid or not scene:
		push_error("Erro ao criar slots! Grid ou cena inválida.")
		return
		
	for i in range(quantity):
		var slot = scene.instantiate()
		if slot is InventorySlot:
			slot.slot_index = i
			slot.category = category
			grid.add_child(slot)
			print("Criado slot %d na grade '%s' com categoria '%s'" % [i, grid.name, category])
		else:
			push_error("A cena instanciada não é um InventorySlot!")

func update_slots():
	print("Updating inventory slots...")
	# Store current items before clearing
	var stored_items = {}
	
	for grid in [grid_items, grid_potions, grid_jewelry, grid_armor, grid_weapons]:
		if grid:
			var grid_items = []
			for slot in grid.get_children():
				if slot is InventorySlot and not slot.is_empty():
					grid_items.append({
						"item_id": slot.item_id,
						"quantity": slot.quantity,
						"category": slot.category,
						"slot_index": slot.slot_index
					})
			stored_items[grid.name] = grid_items
	
	# Reinitialize slots
	initialize_slots()
	
	# Restore items
	for grid_name in stored_items:
		var grid_items = stored_items[grid_name]
		for item_data in grid_items:
			add_item(item_data["item_id"], item_data["quantity"], item_data["category"])
	
	print("Inventory slots update completed")

func add_item(item_id: String, quantity: int, category: String) -> bool:
	print("Attempting to add item: %s (x%d) of category: %s" % [item_id, quantity, category])
	var target_grid = get_grid_by_category(category)
	
	if not target_grid:
		push_error("No grid found for category: %s" % category)
		return false
	
	# Check if grid needs updating
	if target_grid.get_child_count() == 0:
		update_slots()
		target_grid = get_grid_by_category(category)
	
	var remaining_quantity = quantity
	
	# First try to stack with existing items
	for slot in target_grid.get_children():
		if slot is InventorySlot and not slot.is_empty() and slot.item_id == item_id:
			if slot.has_space(remaining_quantity):
				remaining_quantity = slot.set_item(item_id, remaining_quantity)
				if remaining_quantity <= 0:
					return true
	
	# If we still have items to add, find empty slots
	if remaining_quantity > 0:
		for slot in target_grid.get_children():
			if slot is InventorySlot and slot.is_empty():
				remaining_quantity = slot.set_item(item_id, remaining_quantity)
				if remaining_quantity <= 0:
					return true
	
	print("No available slot for category: %s" % category)
	return false

func get_grid_by_category(category: String) -> GridContainer:
	match category:
		"item": return grid_items
		"potion": return grid_potions
		"jewelry": return grid_jewelry
		"armor": return grid_armor
		"weapon": return grid_weapons
		_:
			push_error("Invalid category: %s" % category)
			return null

func _process(_delta):
	if player:
		position = player.position + Vector2(-70, -110)
