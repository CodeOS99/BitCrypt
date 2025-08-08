extends SlimeBoss


func _ready() -> void:
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health
	Globals.slime_boss = self

func _on_animated_sprite_2d_animation_finished() -> void:
	if $FlipParent/AnimatedSprite2D.animation == "death":
		var t = get_tree().create_tween()
		t.tween_property($FlipParent/AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 1)
		t.tween_callback(die)
		print("callign back")
	elif $FlipParent/AnimatedSprite2D.animation != "jump":
		$FlipParent/AnimatedSprite2D.play("jump")

func die():
	print("printing")
	print("Scene change result: ", get_tree().change_scene_to_file("res://Scenes/win.tscn"))
	get_parent().queue_free()
