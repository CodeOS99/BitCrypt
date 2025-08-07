extends base_room

func _enter_tree() -> void:
	init(RoomData.room_type.TRAP)

func _ready() -> void:
	AudioPlayer.play_game_music()
	if openings_cotainer_node == null:
		print("opening_container_node is null; check if it exists and its name is 'all_openings'(contains openings for left, right, etc)")
	if props == null:
		print("props node is null; check if it exists and its name is 'props'(contains all props)")
	if doors == null:
		print("doors node is null; check if it exists and its name is 'doors' and its path is parops/doors(contains all doors)")

	if curr_room_type == RoomData.room_type.COMBAT:
		pass
	
	for opening in openings_cotainer_node.get_children():
		openings.append(opening) # THis is used by the door script
	
	for door in doors.get_children():
		door.entered.connect(door_entered)
		if curr_room_type == RoomData.room_type.COMBAT:
			door.close()
	$enemy_spawner.spawn_enemies_in_area()
