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
	var room_data_path: String = "res://Scripts/Resources/rooms/"
	var dir = DirAccess.open(room_data_path)
	if dir == null:
		push_error("Failed to open directory: %s" % room_data_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var file_path = room_data_path + file_name
			var data = load(file_path) as RoomData
			if data != null:
				room_data.append(data)
		file_name = dir.get_next()

	dir.list_dir_end()
