extends Area2D

@onready var sprite_2d = $Sprite2D
var last_side = ""
func PickUp():
	var dropped: bool = true

#func _on_area_entered(area):
	#if area.has_method("PickWeapon"):
	#self.queue_free()
	#print("arma saiu do chao")
	#area.PickWeapon(self)
	
func _ready():
	var direction = Input.get_axis("move_left", "move_right")	
	#Flipa o sprite
	if direction > 0:
		sprite_2d.flip_h = false
		last_side == "right"
	elif direction < 0:
		sprite_2d.flip_h = true
		sprite_2d.position.x -= 10
		last_side == "left"
	elif direction == 0:
			print(direction)
			print(last_side)
			if last_side == "left":
				sprite_2d.flip_h = true
			
func _on_body_entered(body):
	var dropped: bool = true
	if dropped:
		if body.has_method("PickWeapon"):
			self.queue_free()
			print("arma saiu do chao")
			dropped = false		
			body.PickWeapon(self)
			if body.has_method("drop_weapon"):
				if Input.is_action_just_pressed("use"):
					body.drop_weapon(self)
