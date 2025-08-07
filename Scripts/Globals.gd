class_name Globals
extends Node2D

static var player: Player
static var player_body: CharacterBody2D
static var tyrrany_over_the_blight_of_flesh: int = 0
static var max_tyrrany: int = 100
static var arrows: int = 10
static var damage: int = 0

static func incr_tyrrany(n: int):
	tyrrany_over_the_blight_of_flesh += n
	player.update_tyrrany(tyrrany_over_the_blight_of_flesh)
	if tyrrany_over_the_blight_of_flesh >= max_tyrrany:
		player.become_tyrranous() # ???

static func fire_arrow(n: int):
	arrows -= n
	player.arrow_amount_label.text = str(arrows)
