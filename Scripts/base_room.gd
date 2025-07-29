class_name base_room
extends Node2D

@onready var openings_cotainer_node: Node2D = $all_openings
@onready var props: Node2D = $props
@onready var doors: Node2D = $props/doors
@onready var player: CharacterBody2D = $player
@onready var wall_tilemap: TileMapLayer = $walls

var openings: Array[Opening]

enum room_type {
	COMBAT,
	TRAP,
	PUZZLE
}

@export var curr_room_type: room_type

func _ready() -> void:
	if openings_cotainer_node == null:
		print("opening_container_node is null; check if it exists and its name is 'all_openings'(contains openings for left, right, etc)")
	if props == null:
		print("props node is null; check if it exists and its name is 'props'(contains all props)")
	if doors == null:
		print("doors node is null; check if it exists and its name is 'doors' and its path is parops/doors(contains all doors)")
	for opening in openings_cotainer_node.get_children():
		openings.append(opening) # THis is used by the door script
	
	for door in doors.get_children():
		door.entered.connect(door_entered)
		if curr_room_type == room_type.COMBAT:
			door.close()

func make_random_openings(entered_opening: Opening):
	for opening in openings:
		if opening != entered_opening:
			if randi() % 2 == 0:
				opening.door.become_tile()

func door_entered():
	self.queue_free()
