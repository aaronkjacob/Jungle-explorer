extends Node

var breadcrum_preload = preload("res://breadcrum_stuff/breadcrum.tscn")

@onready var breadcrum_timer: Timer = $breadcrum_timer

var breadcrum_list = []
var breadcrum_amount : int = 10

func _ready() -> void:
	for i in range(breadcrum_amount):
		var breadcrum_instance = breadcrum_preload.instantiate()
		breadcrum_instance.global_position = global.player_pos
		
		breadcrum_list.append(breadcrum_instance)
		get_tree().root.add_child.call_deferred(breadcrum_instance)


func _on_breadcrum_timer_timeout() -> void:
	var moving_breadcrum : Breadcrum = breadcrum_list[0]
	moving_breadcrum.global_position = global.player_pos
	
	breadcrum_list.erase(moving_breadcrum)
	breadcrum_list.append(moving_breadcrum)
