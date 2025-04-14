extends InventorySlot
class_name ItemSlot

const MAX_STACK_SIZE = 16

func _ready():
	super._ready()

func has_space(amount: int = 1) -> bool:
	if is_empty():
		return true
	return quantity + amount <= MAX_STACK_SIZE

func set_item(new_item_id: String, new_quantity: int) -> int:
	if new_item_id.is_empty():
		clear_slot()
		return 0
	
	var remaining = 0
	
	# If slot is empty or getting same item
	if is_empty() or item_id == new_item_id:
		item_id = new_item_id
		var total_quantity = quantity + new_quantity
		
		# Check if exceeds max stack
		if total_quantity > MAX_STACK_SIZE:
			quantity = MAX_STACK_SIZE
			remaining = total_quantity - MAX_STACK_SIZE
		else:
			quantity = total_quantity
		
		# Update texture
		var texture_path = "res://assets/%s.png" % item_id
		if ResourceLoader.exists(texture_path):
			texture = load(texture_path)
			if quantity_label:
				quantity_label.text = str(quantity)
				quantity_label.visible = quantity > 1
		else:
			print("Error: texture not found for item: ", item_id)
			clear_slot()
	else:
		# If trying to add different item to non-empty slot
		remaining = new_quantity
	
	return remaining
