extends CanvasLayer

signal transitioned

func transition():
	AudioPlayer.transitionPlayer.play()
	$AnimationPlayer.play("cover_up",1, 1.0)
	await $AnimationPlayer.animation_finished
	transitioned.emit()
	$AnimationPlayer.play_backwards("cover_up")
