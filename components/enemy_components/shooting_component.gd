extends Node
class_name ShootingComponent

@onready var player: Player = get_tree().current_scene.get_node("Player")
var player_pos : Vector2

@export var aim : float = .5
@export var shooting_cooldown : float = 1.0

# this variable helps the shooters have a different shooting cooldown so shots are less predictable
@export var cooldown_offset_range = .2

@export var PROJECTILE = preload("res://bow_and_arrow/arrow.tscn")
 
@onready var shooting_cooldown_timer: Timer = $shooting_cooldown

func _ready() -> void:
	var shooting_cooldown_offset = randf_range(-cooldown_offset_range,cooldown_offset_range)
	shooting_cooldown_timer.wait_time = shooting_cooldown + shooting_cooldown_offset

func _process(_delta: float) -> void:
	player_pos = player.global_position



func _on_shooting_cooldown_timeout() -> void:
	if get_parent().detected:
		# make an arrow instance
		var arrow_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(arrow_instance)
		arrow_instance.global_position = get_parent().global_position
		arrow_instance.look_at(player_pos)
		arrow_instance.rotation_degrees += randf_range(-aim,aim)
		
		shooting_cooldown_timer.start()
