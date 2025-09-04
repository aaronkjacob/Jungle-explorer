extends Node
var BREADCRUM = preload("res://breadcrum.tscn")

@onready var breadcrums_move_timer: Timer = $"breadcrums_timer"

var breadcrums_amount = 10

var breadcrums = []

func _ready() -> void:
	for i in range(breadcrums_amount):
		spawn_breadcrum(global.player_pos)

func _process(delta: float) -> void:
	for bread in breadcrums:
		if bread.enemy_in_sight:
			get_tree().root.remove_child.call_deferred(bread)

func spawn_breadcrum(pos):
	var breadcrum = BREADCRUM.instantiate()
	breadcrum.global_position = pos
	get_tree().root.add_child.call_deferred(breadcrum)
	breadcrums.append(breadcrum)


func _on_breadcrum_timer_timeout() -> void:
	spawn_breadcrum(global.player_pos)
