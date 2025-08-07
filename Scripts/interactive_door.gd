class_name InteractiveDoor
extends Door

@export var player_spawn_offset_m: Vector2i = Vector2i(-25, 25)

@onready var interactive_help_shower = $interactHelpShower

var is_player_in_range: bool = false


func _ready() -> void:
	exit_dir = -dir
	interactive_help_shower.player_enter.connect(_on_interact_help_shower_player_enter)
	interactive_help_shower.player_exit.connect(_on_interact_help_shower_player_exit)
	is_interactive = true
	for data in Globals.room_data:
		# If the allowed room types array has zero elements,
		# I take it to be all rooms allowed
		# If this is not the case, check if this data(which is a room data)
		# Is allowed
		if len(allowed_room_types) != 0 and not data.curr_room_type in allowed_room_types:
			continue
		
		# Check if this data's type is disallowed
		if data.curr_room_type in global_disallowed_types:
			continue
		
		for not_possible_dir in data.excluded_openings: # excluded are the ones for which there is no door
			if not_possible_dir == exit_dir:
				continue
		print(str(data.has_interact_openings as int) + " yes ")
		if data.has_interact_openings:
			print("odjfosjdo")
			possibleRooms.append(data.scene)

func _process(delta: float) -> void:
	if is_player_in_range and Input.is_action_just_pressed("use"):
		
		spawn_room()

func close():
	pass

func open():
	pass

func become_tile():
	pass

func _on_interact_help_shower_player_enter() -> void:
	is_player_in_range = true

func _on_interact_help_shower_player_exit() -> void:
	is_player_in_range = false
