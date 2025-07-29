class_name Door
extends Node2D

signal entered

@export var dir: Vector2i

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
		for opening_dir in data.excluded_openings:
			if opening_dir == exit_dir:
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
	animated_sprite.play("close")

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

	var idx = randi() % possibleRooms.size()
	var chosen_scene: PackedScene = possibleRooms[idx]

	var new_room = chosen_scene.instantiate() as base_room
	get_tree().root.call_deferred('add_child', new_room)

	await get_tree().process_frame

	for opening in new_room.openings:
		if opening.coords == exit_dir:
			new_room.player.global_position = opening.player_spawn_pos + Vector2(opening.coords) * Vector2(-25, 25)
			new_room.make_random_openings(opening)

	entered.emit()
