extends ColorRect

func _process(delta: float) -> void:
	if Globals.slime_boss != null and self.modulate.a == 0:
		print("FKDISO")
		var t = get_tree().create_tween()
		t.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
