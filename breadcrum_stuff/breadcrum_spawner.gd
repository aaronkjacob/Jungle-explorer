extends Node

var breadcrum_preload = preload("res://breadcrum_stuff/breadcrum.tscn")

@onready var breadcrum_timer: Timer = $breadcrum_timer

var breadcrum_list = []
@export var breadcrum_amount : int = 10
@export var breadcrum_spawn_wait_time : float = .7


func _ready() -> void:
	await get_tree().physics_frame
	breadcrum_timer.wait_time = breadcrum_spawn_wait_time
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
