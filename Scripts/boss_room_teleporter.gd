extends Node2D

var boss_room = preload("res://Scenes/boss_room.tscn")

func _on_interact_help_shower_player_interact() -> void:
	spawn_room()

func spawn_room():
	var room = create_room()
	add_room_to_scene(room)
	await get_tree().process_frame
	setup_player_in_room(room)

func create_room():
	var new_room = boss_room.instantiate()
	return new_room

func add_room_to_scene(new_room):
	get_tree().root.call_deferred("add_child", new_room)

func setup_player_in_room(new_room):
	transfer_player_to_new_room(new_room)

func transfer_player_to_new_room(new_room):
	var player := Globals.player_body
	player.get_parent().remove_child(player)
	new_room.add_child(player)
	player.global_position = new_room.player_spawn_pos
	get_parent().queue_free()
