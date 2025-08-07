class_name RoomData
extends Resource

enum room_type {
	COMBAT,
	TRAP,
	PUZZLE,
	ACCESSIBLE_TREASURE, # can be spawned randomly; has openings and doors
	LOCKED_TREASURE # can't be spawned randomly; other means of exits such as stairs or ladders
}

@export var scene: PackedScene
@export var curr_room_type: room_type
@export var has_interact_openings: bool = false
@export var excluded_openings: Array[Vector2i] # prelimnary check to decide if this scene is posisble
# !! in Quadrant I
