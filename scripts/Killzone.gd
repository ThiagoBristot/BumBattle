extends Area2D

@onready var timer = $Timer

func _on_body_entered(player):
	print ("morreu")
	timer.start()

func _on_timer_timeout():
	get_tree().reload_current_scene()
