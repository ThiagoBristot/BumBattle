extends Node
class_name StateMachine

var current_state: State
var states: Dictionary = {}

func _ready():
	# Initialize with first state found if none is set
	if not current_state and get_child_count() > 0:
		current_state = get_child(0) as State
		current_state.enter()
		print("Initial state: ", current_state.name)
		print("Available states: ", states)

func _process(delta):
	if current_state:
		current_state.process_state(delta)

func _physics_process(delta):  # Fixed method name
	if current_state:
		current_state.physics_process_state(delta)

func add_state(state: State):
	var state_name = state.name.to_lower().replace("state", "")
	states[state_name] = state
	print("Added state: ", state_name)

func change_state(state_name: String):
# Remove "state" from the name and convert to lower case
	var trimmed_name = state_name.to_lower().replace("state", "")
	print("Attempting to change to state: ", trimmed_name)
	
	if current_state:
		current_state.exit()

	if states.has(trimmed_name):
		current_state = states[trimmed_name]
		current_state.enter()
		print("Changed to state: ", trimmed_name)
	else:
		push_error("State not found: " + trimmed_name)
		print("Available states: ", states.keys())
