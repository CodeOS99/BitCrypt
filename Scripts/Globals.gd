class_name Globals
extends Node2D

static var player: Player
static var player_body: CharacterBody2D
static var tyrrany_over_the_blight_of_flesh: int = 0
static var max_tyrrany: int = 100
static var arrows: int = 10
static var damage: int = 0
static var room_data = []
static var slime_boss: SlimeBoss
static var has_goblin_blessing: bool = false

static func reset():
	player = null
	player_body = null
	tyrrany_over_the_blight_of_flesh = 0
	max_tyrrany = 100
	arrows = 10
	damage = 0
	room_data = []
	slime_boss = null
	has_goblin_blessing = false
	load_room_data_from_directory()

static func incr_tyrrany(n: int):
	tyrrany_over_the_blight_of_flesh += n
	player.update_tyrrany(tyrrany_over_the_blight_of_flesh)
	if tyrrany_over_the_blight_of_flesh >= max_tyrrany:
		player.become_tyrranous() # ???

static func fire_arrow(n: int):
	arrows -= n
	player.arrow_amount_label.text = str(arrows)

static func load_room_data_from_directory() -> void:
	# Brute-force approach: manually specify every room resource
	var manual_paths = [
		"res://Scripts/Resources/rooms/combat_library.tres",
		"res://Scripts/Resources/rooms/fire_real_treasure.tres",
		"res://Scripts/Resources/rooms/first_treasure.tres",
		"res://Scripts/Resources/rooms/quarry_one.tres"
	]

	for file_path in manual_paths:
		var data = load(file_path) as RoomData
		if data != null:
			room_data.append(data)
