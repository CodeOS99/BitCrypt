extends VBoxContainer

var curr_focus_idx: int = 0
var number_of_options: int = 0

@onready var beepSoundPlayer = $"../beepSound"
@onready var selectSoundPlayer = $"../selectSound"

func _ready() -> void:
	number_of_options = get_child_count()
	get_child(curr_focus_idx).grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		curr_focus_idx = (curr_focus_idx+1) % number_of_options
		get_child(curr_focus_idx).grab_focus()
		beepSoundPlayer.play()
	elif Input.is_action_just_pressed("up"):
		curr_focus_idx = (curr_focus_idx - 1 + number_of_options) % number_of_options
		get_child(curr_focus_idx).grab_focus()
		beepSoundPlayer.play()

func _on_back_button_pressed() -> void:
	selectSoundPlayer.play()
	await selectSoundPlayer.finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
