extends "res://Scripts/keyboard_btn_container.gd"


func _ready() -> void:
	Globals.load_room_data_from_directory()
	number_of_options = get_child_count()
	get_child(curr_focus_idx).grab_focus()
