class_name base_room
extends Node2D

@onready var openings_cotainer_node: Node2D = $all_openings
@onready var props: Node2D = $props
@onready var doors: Node2D = $props/doors
@onready var player: CharacterBody2D = $player

var openings: Array[Opening]

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

func door_entered():
	print("Hello")
	self.queue_free()
