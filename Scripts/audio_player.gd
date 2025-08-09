extends Node

@export var beepSoundPlayer: AudioStreamPlayer2D
@export var selectSoundPlayer: AudioStreamPlayer2D
@onready var signboardPlayer = $signboard
@onready var bowShoot = $BowShoot
@onready var slimeJumpPlayer = $Jump
@onready var slimeDiePlayer = $SlimeDie
@onready var swordPlayer = $Sword
@onready var tyrranyMaxPlayer = $TyrranyMax
@onready var chestPlayer = $Chest
@onready var hitSound = $Hit
@onready var arrowHit = $ArrowHit
@onready var blessingErected = $BlessingErected
@onready var blessingBlow = $BlessingBlow

var curr_bg_player: AudioStreamPlayer2D

func play_music(player: AudioStreamPlayer2D):
	if curr_bg_player and curr_bg_player != player:
		curr_bg_player.stop()
	if not player.playing:
		player.play()
	curr_bg_player = player

func playtitle_screen_music():
	play_music($title_screen_music)

func play_game_music():
	play_music($game_music)

func play_shop_music():
	play_music($shop_music)

func play_boss_bg_music():
	play_music($boss_bg_music)

func play_end_music():
	play_music($end_bg_music)

func play_game_over_music():
	play_music($game_over_bg_music)
