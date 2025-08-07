extends Button

@export var cost = 10

func _process(delta: float) -> void:
	disabled = not Globals.player.coins >= cost
