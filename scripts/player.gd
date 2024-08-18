extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var carrying_gun: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var muzzle = $Marker2D
var weapon = null  # Referência à arma atual

@onready var animated_sprite = $AnimatedSprite2D
@onready var sprite_2d = get_tree().get_nodes_in_group("armas")


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

#pegar arma
func PickWeapon(weapon):
	print(weapon)
	var weapon_scene = preload("res://scenes/weapon.tscn")
	var weapon_instance = weapon_scene.instantiate()
	print("Pegando arma:", weapon_instance)
	weapon = weapon_instance  # Armazenar a referência à arma
	print(weapon_instance.position, muzzle.global_position)
	carrying_gun = true  # Atualiza o estado para indicar que está carregando a arma
	if carrying_gun:
		add_child(weapon_instance)  # Parentear a arma ao jogador
		weapon_instance.position = Vector2(muzzle.global_position)
		weapon_instance.rotation = 0  # Reseta a rotação, se necessário
		# Obtém a direção de entrada
func drop_weapon(weapon):
	if carrying_gun:
		if Input.is_action_just_pressed("use"):
			print("dropando arma")
			weapon.queue_free()  # Remover a arma da cena
			get_tree().current_scene.add_child(weapon)
			#weapon.velocity.x.move_toward(velocity.x, 0, SPEED)
			weapon = null  # Limpa a referência
			carrying_gun = false  # Atualiza o estado

#funcao para atirar
#func shoot():
#	if weapon:
#		weapon.shoot()

#func _on_killzone_body_entered(body):
#	pass # Replace with function body.


#func pick_gun():
	#if not has_node(".") and weapon_collide_with:
	#	var ref_weapon = weapon_collide_with.get_child(2)

		
