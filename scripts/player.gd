extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Adiciona a gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += gravity * delta

		# Lida com o pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Obtém a direção de entrada 
	var direction = Input.get_axis("move_left", "move_right")

	#Flipa o sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif  direction < 0:
		animated_sprite.flip_h = true	
	
	#toca a animação:
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	#aplica movimento
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()



var inventory = []  # Inventário do jogador
var hand_position = Vector2(50, 0)  # Posição da mão do jogador

#Arma do personagem
var weapon = null # Variável para armazenar a arma atual

#pegar arma
func _on_Weapon_pickup(weapon):
	add_weapon(weapon)

func add_weapon(weapon):
	# Adiciona a arma ao inventário
	inventory.append(weapon)
	# Ajusta a posição da arma na mão do jogador
	weapon.position = global_position + hand_position
	weapon.set_as_toplevel(true)  # Torna o revolver um nó de nível superior para manter a posição




#funcao para atirar
func shoot():
	if weapon:
		weapon.shoot()

func _on_killzone_body_entered(body):
	pass # Replace with function body.
