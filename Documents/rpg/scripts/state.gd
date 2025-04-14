extends Node
class_name State

var player: Player
var state_machine: Node

func enter():
	pass

func exit():
	pass

func process_state(delta: float):
	pass

func physics_process_state(delta: float):
	pass
	
func transition_to(new_state: String):
	if state_machine:
		state_machine.change_state(new_state)
