extends Label

func _process(delta: float) -> void:
	text = "coins - " + str(Globals.player.coins)
