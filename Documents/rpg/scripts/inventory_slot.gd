extends TextureRect
class_name InventorySlot

@export var slot_index: int = 0
@export var category: String = ""

var item_id: String = ""
var quantity: int = 0

@onready var quantity_label: Label = $QuantityLabel

func _ready():
	# Inicializa a quantidade oculta
	if quantity_label:
		quantity_label.visible = false

func is_empty() -> bool:
	return item_id.is_empty() or quantity <= 0

func set_item(new_item_id: String, new_quantity: int):
	if new_item_id.is_empty():
		clear_slot()
		return
	
	item_id = new_item_id
	quantity = new_quantity

	# Carrega a textura correspondente
	var texture_path = "res://assets/%s.png" % item_id
	print("Tentando carregar:", texture_path)

	if ResourceLoader.exists(texture_path):
		texture = load(texture_path)
		print("Textura carregada com sucesso!")
		if quantity_label:
			quantity_label.text = str(quantity)
			quantity_label.visible = quantity > 1
	else:
		print("Erro: textura não encontrada!")
		clear_slot()

func clear_slot():
	item_id = ""
	quantity = 0
	texture = null
	if quantity_label:
		quantity_label.visible = false
