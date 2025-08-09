extends Button

@export var cost = 100

func _process(delta: float) -> void:
	if Globals.player.coins >= cost:
		disabled = false
	else:
		disabled = true
	if Globals.has_goblin_blessing:
		disabled = false
