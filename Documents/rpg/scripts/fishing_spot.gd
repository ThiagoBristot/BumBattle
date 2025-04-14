extends Area2D
class_name FishingSpot

@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var fish_texture: Sprite2D = $CanvasLayer/FishTexture  # Corrigido caminho

var is_active: bool = false
var catch_progress: float = 0.0
var player_ref: Player = null

func interact(player: Player):
	if is_active:
		return  # Evita iniciar um minigame enquanto outro está rodando
	player_ref = player
	player.start_fishing()
	start_minigame()

func start_minigame():
	is_active = true
	catch_progress = 0.0
	progress_bar.visible = true
	fish_texture.position = Vector2(randf_range(50, 200), 0)

func _process(delta):
	if is_active:
		if Input.is_action_pressed("ui_accept"):
			catch_progress += delta * 50  # Aumento mais rápido
		else:
			catch_progress -= delta * 15  # Diminuição mais lenta

		catch_progress = clamp(catch_progress, 0.0, 100.0)
		progress_bar.value = catch_progress

		if catch_progress >= 100:
			complete_fishing()

#func complete_fishing():
#	is_active = false
#	progress_bar.visible = false
#	print("Peixe capturado!")
#	
#	if player_ref:
#		player_ref.inventory.add_item("fish", 1)  # Exemplo de integração com inventário
