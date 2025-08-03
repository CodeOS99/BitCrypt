class_name Door
extends Node2D

signal entered

@export var dir: Vector2i
@export var allowed_room_types: Array[RoomData.room_type]
@export var global_disallowed_types: Array[RoomData.room_type] = [RoomData.room_type.LOCKED_TREASURE]

@onready var enter_area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_blocker: StaticBody2D = $StaticBody2D

var room_data_path: String = "res://Scripts/Resources/rooms/"

var room_data: Array[RoomData] = []

var exit_dir: Vector2i
var possibleRooms: Array[PackedScene] = []

var is_open: bool = true

func _ready() -> void:
	exit_dir = -dir
	enter_area.body_entered.connect(_on_area_2d_body_entered)
	
	if not is_open:
		close()
	else:
		open()
	
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

func close():
	is_open = false
	player_blocker.set_collision_layer_value(1, true)
	animated_sprite.play("tile") # Tile because close looks like shit :D

func open():
	is_open = true
	player_blocker.set_collision_layer_value(1, false)
	animated_sprite.play("open")

func become_tile():
	is_open = false
	player_blocker.visible = true
	animated_sprite.play("tile")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_open:
		return

	if body.name != "player":
		return

	if possibleRooms.is_empty():
		print("No matching room found.")
		return

	spawn_room()

func spawn_room():
	var idx = randi() % possibleRooms.size()
	var chosen_scene: PackedScene = possibleRooms[idx]

	var new_room = chosen_scene.instantiate() as base_room
	get_tree().root.call_deferred("add_child", new_room)

	await get_tree().process_frame

	for opening in new_room.openings:
		if opening.coords == exit_dir:
			if opening.door != null and opening.door.get_class() == self.get_class():
				var player := Globals.player_body
				player.get_parent().remove_child(player)
				new_room.add_child(player)
				
				player.global_position = opening.player_spawn_pos + Vector2(exit_dir) * Vector2(-25, 25)

				new_room.make_random_openings(opening)

	entered.emit()
