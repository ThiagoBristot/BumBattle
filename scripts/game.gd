extends Node2D

@onready var timer = $Timer
@onready var game_node = $"."
@onready var rigid_body_2d = $"."


func _ready():
	# Configura o timer para iniciar o spawn
	print("timer startou")
	timer.start()

func _on_timer_timeout():
	print("timer terminou")
	# Instancia o revolver e o adiciona ao nó 'Game'
	var revolver_scene = preload("res://scenes/weapon.tscn")
	var revolver_instance = revolver_scene.instantiate()
	revolver_instance.position = Vector2(43, 70)
	
	# Adiciona o revolver ao nó 'Game' (ajuste conforme a estrutura do seu projeto)
	if game_node:
		game_node.add_child(revolver_instance)
		print("Revolver adicionado ao game_node")
	else:
		print("game_node não encontrado")




		
