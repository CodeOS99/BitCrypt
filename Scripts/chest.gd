extends Node2D

var opened = false

func _on_interact_help_shower_player_interact() -> void:
	if $AnimatedSprite2D.animation != "open" and not opened:
		AudioPlayer.chestPlayer.play() 
		$AnimatedSprite2D.play("open")
		var coin_incr = 50 + (randi() % 50)
		Globals.player.add_coins(coin_incr)
		opened = false 
