extends VBoxContainer

var curr_focus_idx: int = 0
var number_of_options: int = 0

@export var heal_amount = 10
@export var arrow_amount = 10
@export var max_health_incr_amount = 10
@export var damage_incr_amount = 5

func _ready():
	number_of_options = get_child_count()
	await get_tree().process_frame  # Wait a frame
	get_child(curr_focus_idx).grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		curr_focus_idx = (curr_focus_idx+1) % number_of_options
		get_child(curr_focus_idx).grab_focus()
		AudioPlayer.beepSoundPlayer.play()
	elif Input.is_action_just_pressed("up"):
		curr_focus_idx = (curr_focus_idx - 1 + number_of_options) % number_of_options
		get_child(curr_focus_idx).grab_focus()
		AudioPlayer.beepSoundPlayer.play()

func _on_heal_btn_pressed() -> void:
	Globals.player.heal(heal_amount)
	Globals.player.buy_of($HealBtn.cost)
	AudioPlayer.selectSoundPlayer.play()

func _on_bow_btn_pressed() -> void:
	Globals.player.equip("bow")
	Globals.player.buy_of($BowBtn.cost)
	AudioPlayer.selectSoundPlayer.play()

func _on_arrow_btn_pressed() -> void:
	print(arrow_amount)
	Globals.player.gain_arrows(arrow_amount)
	Globals.player.buy_of($ArrowBtn.cost)
	AudioPlayer.selectSoundPlayer.play()

func _on_sword_btn_pressed() -> void:
	Globals.player.equip("sword")
	Globals.player.buy_of($SwordBtn.cost)
	AudioPlayer.selectSoundPlayer.play()

func _on_max_hp_btn_pressed() -> void:
	Globals.player.incr_max_health(max_health_incr_amount)
	Globals.player.buy_of($MaxHPBtn.cost)
	$MaxHPBtn.cost = floor($MaxHPBtn.cost * 1.5)
	$MaxHPBtn.text = "+{hp} max hp - {cost} coins".format({
		"hp": max_health_incr_amount,
		"cost": $MaxHPBtn.cost
	})
	AudioPlayer.selectSoundPlayer.play()

func _on_atk_dmg_btn_pressed() -> void:
	Globals.player.incr_dmg(damage_incr_amount)
	Globals.player.buy_of($AtkDmgBtn.cost)
	$AtkDmgBtn.cost = floor($AtkDmgBtn.cost * 1.5)
	$AtkDmgBtn.text = "+ {damage} damage - {cost} coins".format({
		"damage": damage_incr_amount,
		"cost": $AtkDmgBtn.cost
	})
	AudioPlayer.selectSoundPlayer.play()

func _on_back_btn_pressed() -> void:
	$"..".visible = false
	AudioPlayer.play_game_music()
	get_tree().paused = false

func _on_blessings_btn_pressed() -> void:
	Globals.has_goblin_blessing = true
	Globals.player.buy_of($BlessingsBtn.cost)
