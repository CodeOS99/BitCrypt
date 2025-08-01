class_name InteractiveDoor
extends Door

@export var player_spawn_offset_m: Vector2i = Vector2i(-25, 25)

@onready var interactive_help_shower = $interactHelpShower

var is_player_in_range: bool = false

func _ready() -> void:
	exit_dir = -dir
	interactive_help_shower.player_enter.connect(_on_interact_help_shower_player_enter)
	interactive_help_shower.player_exit.connect(_on_interact_help_shower_player_exit)
	
	load_room_data_from_directory(room_data_path)

	for data in room_data:
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
		possibleRooms.append(data.scene)
	

func _process(delta: float) -> void:
	if is_player_in_range and Input.is_action_just_pressed("use"):
		spawnRoom()

func load_room_data_from_directory(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Failed to open directory: %s" % path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var file_path = path + file_name
			var data = load(file_path) as RoomData
			if data != null:
				room_data.append(data)
		file_name = dir.get_next()

	dir.list_dir_end()
	
func spawnRoom():
	var idx = randi() % possibleRooms.size()
	var chosen_scene: PackedScene = possibleRooms[idx]

	var new_room = chosen_scene.instantiate() as base_room

	get_tree().root.call_deferred('add_child', new_room)
	await get_tree().process_frame # wait for it to load!
	for opening in new_room.openings:
		if opening.coords == exit_dir:
			print("Kgefoji")
			new_room.player.global_position = opening.player_spawn_pos + Vector2(opening.coords) * Vector2(-25, 25)
	entered.emit()

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
