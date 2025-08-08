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

func playtitle_screen_music():
	if $title_screen_music.playing == false:
		$title_screen_music.play()
		curr_bg_player = $title_screen_music

func play_game_music():
	if $game_music.playing == false:
		curr_bg_player.stop()
		$game_music.play()
		curr_bg_player = $game_music

func play_shop_music():
	if $shop_music.playing == false:
		curr_bg_player.stop()
		$shop_music.play()
		curr_bg_player = $shop_music

func play_boss_bg_music():
	if $boss_bg_music.playing == false:
		curr_bg_player.stop()
		$boss_bg_music.play()
		curr_bg_player = $boss_bg_music

func play_end_music():
	if $end_bg_music.playing == false:
		curr_bg_player.stop()
		$end_bg_music.play()
		curr_bg_player = $end_bg_music
