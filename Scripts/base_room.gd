class_name base_room
extends Node2D

@onready var openings_cotainer_node: Node2D = $all_openings
@onready var props: Node2D = $props
@onready var doors: Node2D = $props/doors
@onready var wall_tilemap: TileMapLayer = $walls

var openings: Array[Opening]

@export var curr_room_type: RoomData.room_type

func init(this_rooms_type: RoomData.room_type):
	self.curr_room_type = this_rooms_type

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

func make_random_openings(entered_opening: Opening):
	for opening in openings:
		if opening != entered_opening:
			if randi() % 2 == 1:
				opening.door.become_tile()
			else:
				opening.door.open()
		else:
			print("ksifgs")
			opening.door.open()

func door_entered():
	self.queue_free()
