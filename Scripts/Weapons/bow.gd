extends Node2D

var arrow: PackedScene = preload("res://Scenes/weapons/arrow.tscn")
var facing_dir: String
var can_shoot = true

func _process(delta: float) -> void:
	if "atk" not in $AnimationPlayer.current_animation:
		var pos = get_global_mouse_position() - global_position
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
		if Input.is_action_pressed("attack") and Globals.arrows > 0:
			type = "atk"
			Globals.fire_arrow(1)
		
		$AnimationPlayer.play(facing_dir + "_" + type)
	if "atk" in $AnimationPlayer.current_animation and $AnimatedSprite2D.frame == 3:
		if can_shoot:
			Globals.player.camera.start_shake(0.5 , 5.0, 5.0)
			AudioPlayer.bowShoot.play()
			can_shoot = false
			var n := arrow.instantiate()
			n.global_position = $ArrowSpawnPoint.global_position
			n.facing_dir = facing_dir
			get_tree().root.add_child(n)
	else:
		can_shoot = true
