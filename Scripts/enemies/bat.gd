extends StaticBody2D

var max_heatlh:int = 10
var health:int = 10

func _ready() -> void:
	$ProgressBar.max_value = max_heatlh
	$ProgressBar.value = $ProgressBar.max_value

func _process(delta: float) -> void:
	if $FlipParent/AnimatedSprite2D.animation == "fly":
		global_position = lerp(global_position, Globals.player_body.global_position, 0.03)
	if (Globals.player_body.global_position - self.global_position).x > 0:
		$FlipParent.scale.x = 1
	else:
		$FlipParent.scale.x = -1

func _on_player_detector_player_enter() -> void:
	$FlipParent/AnimatedSprite2D.play("attack")
	
func take_damage(n: int):
	health -= n
	if health > 0:
		$FlipParent/AnimatedSprite2D.play("hurt")
	else:
		$FlipParent/AnimatedSprite2D.play("death")
	$ProgressBar.value = health

func _on_animated_sprite_2d_animation_finished() -> void:
	if $FlipParent/AnimatedSprite2D.animation not in ["fly", "death"]:
		$FlipParent/AnimatedSprite2D.play("fly")
	elif $FlipParent/AnimatedSprite2D.animation == "death":
		var t = get_tree().create_tween()
		t.tween_property($FlipParent/AnimatedSprite2D, "modulate", Color(255, 255, 255, 0), 1)
		t.tween_callback(self.queue_free)
