extends Node2D

func _ready() -> void:
	$damager.parent_body = get_parent().get_parent()

func _process(delta: float) -> void:
	if "atk" not in $AnimationPlayer.current_animation:
		$damager.active = false
		var pos = get_global_mouse_position() - global_position
		var facing_dir: String
		if abs(pos.x) > abs(pos.y):
			if pos.x < 0:
				facing_dir = "left"
			else:
				facing_dir = "right"
		else:
			if pos.y < 0:
				facing_dir = "up"
			else:
				facing_dir = "down"
		
		var type: String = "face"
		if Input.is_action_pressed("attack"):
			type = "atk"
		
		$AnimationPlayer.play(facing_dir + "_" + type)
		if type == "atk":
			AudioPlayer.swordPlayer.play()
	else:
		$damager.active = true
