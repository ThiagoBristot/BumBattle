extends Node2D

enum State { IDLE, WALKING, INTERACTING, FISHING }

var current_state: State = State.IDLE
var player: CharacterBody2D

func _init(player_node):
	player = player_node

func change_state(new_state: State):
	if current_state == new_state:
		return
	
	exit_state(current_state)
	current_state = new_state
	enter_state(new_state)

func enter_state(state: State):
	match state:
		State.IDLE:
			player.animation_tree.set("parameters/Idle/active", true)
		State.WALKING:
			player.animation_tree.set("parameters/Walk/active", true)
		State.INTERACTING:
			pass  # Pode adicionar animação específica depois
		State.FISHING:
			player.start_fishing()
func exit_state(state: State):
	match state:
		State.WALKING:
			player.animation_tree.set("parameters/Walk/active", false)
