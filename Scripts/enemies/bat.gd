extends StaticBody2D

var health:int = 5

func _process(delta: float) -> void:
	if $AnimatedSprite2D.animation == "fly":
		global_position = lerp(global_position, Globals.player_body.global_position, 0.03)

func _on_player_detector_player_enter() -> void:
	$AnimatedSprite2D.play("attack")
	
func take_damage(n: int):
	print("damagin take")
	health -= n
	if health > 0:
		$AnimatedSprite2D.play("hurt")
	else:
		$AnimatedSprite2D.play("death")
	$ProgressBar.value = health

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation not in ["fly", "death"]:
		$AnimatedSprite2D.play("fly")
	elif $AnimatedSprite2D.animation == "death":
		var t = get_tree().create_tween()
		t.tween_property($AnimatedSprite2D, "modulate", Color(255, 255, 255, 0), 1)
		t.tween_callback(self.queue_free)
