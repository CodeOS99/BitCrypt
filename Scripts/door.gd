class_name Door
extends Node2D

signal entered

@export var dir: Vector2i
@export var allowed_room_types: Array[RoomData.room_type]
@export var global_disallowed_types: Array[RoomData.room_type] = [RoomData.room_type.LOCKED_TREASURE]
@export var is_interactive: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var enter_area: Area2D
var player_blocker: StaticBody2D

var exit_dir: Vector2i
var possibleRooms: Array[PackedScene] = []

var is_open: bool = true
var travelled_once = false

func _ready() -> void:
	if $Area2D != null:
		enter_area = $Area2D
	if $StaticBody2D != null:
		var player_blocker = $StaticBody2D

	exit_dir = -dir
	enter_area.body_entered.connect(_on_area_2d_body_entered)
	
	if not is_open:
		close()
	else:
		open()
		
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
		possibleRooms.append(data.scene)

func close():
	is_open = false
	if player_blocker:
		player_blocker.set_collision_layer_value(1, true)
	animated_sprite.play("tile") # Tile because close looks like shit :D

func open():
	is_open = true
	if player_blocker:
		player_blocker.set_collision_layer_value(1, false)
	animated_sprite.play("open")

func become_tile():
	is_open = false
	if player_blocker:
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
	if travelled_once:
		return
	travelled_once = true
	var room = create_room()
	add_room_to_scene(room)
	await get_tree().process_frame
	setup_player_in_room(room)
	entered.emit()

func create_room() -> base_room:
	var idx = randi() % possibleRooms.size()
	var chosen_scene: PackedScene = possibleRooms[idx]
	var new_room = chosen_scene.instantiate() as base_room
	return new_room

func add_room_to_scene(new_room: base_room):
	get_tree().root.call_deferred("add_child", new_room)

func setup_player_in_room(new_room: base_room):
	for opening in new_room.openings:
		if opening.coords == exit_dir:
			if opening.door != null and opening.door.is_interactive == self.is_interactive:
				transfer_player_to_new_room(opening, new_room)
				new_room.make_random_openings(opening)

func transfer_player_to_new_room(opening, new_room: base_room):
	var player := Globals.player_body
	player.get_parent().remove_child(player)
	new_room.add_child(player)
	player.global_position = opening.player_spawn_pos + Vector2(exit_dir) * Vector2(-25, 25)
