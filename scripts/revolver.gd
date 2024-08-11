extends RigidBody2D

# Variáveis do revolver
const MAX_AMMO = 6
var current_ammo = MAX_AMMO
var reload_time = 3.0 # Tempo para recarregar o revolver

@onready var sprite = $Sprite2D
@onready var timer = $Timer
#func _ready():
	#print ("Timer startou")
	#timer.start()
	# Configurar o timer para controlar o tempo de spawn

#func _on_timer_timeout():
	#print ("Timer terminou")
	# Instancia o revolver e o adiciona à cena principal
	#var revolver_scene = preload("res://scenes/revolver.tscn")
	#var revolver_instance = revolver_scene.instantiate()
	
	# Define a posição de spawn do revolver
	#revolver_instance.position = Vector2(100, 100)

	# Adiciona o revolver à cena principal
	#get_tree().root.add_child(revolver_instance)
	
func _on_body_entered(body):
	print("player pegou o revolver")
	pickup_revolver(body)

func pickup_revolver(player):
	# Remove o revolver do cenário e o adiciona ao jogador
	print("Item pego")
	queue_free()
	player._on_Weapon_pickup(self) # Notifica o jogador que pegou o revolver

func shoot():
	if current_ammo > 0:
		current_ammo -= 1
		# Adicione aqui a lógica para disparar a bala
	if current_ammo == 0:
		reload()

func reload():
	# Recarrega o revolver
	current_ammo = MAX_AMMO
	# Adicione lógica para indicar que o revolver está recarregando, se necessário


