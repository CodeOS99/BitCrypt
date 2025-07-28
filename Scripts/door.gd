class_name Door
extends Node2D

signal entered

@export var dir: Vector2i
@export var room_data: Array[RoomData]

var exit_dir: Vector2i

var possibleRooms: Array[PackedScene] = []

func _ready() -> void:
	exit_dir = -dir
	
	for data in room_data:
		for opening_dir in data.openings:
			if opening_dir == exit_dir:
				possibleRooms.append(data.scene)
				break

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return
		
	if possibleRooms.is_empty():
		print("No matching room found.")
		return
		
	var idx = randi() % possibleRooms.size()
	var chosen_scene: PackedScene = possibleRooms[idx]

	var new_room = chosen_scene.instantiate() as base_room
	get_tree().root.call_deferred('add_child', new_room)  # No deferred

	await get_tree().process_frame  # Wait one frame so _ready() runs

	for opening in new_room.openings:
		if opening.coords == exit_dir:
			new_room.player.global_position = opening.player_spawn_pos
			print(new_room.player)

	entered.emit()
