extends Node

var player_pos : Vector2
var player : Player
@onready var Game_node : Node2D = get_tree().root.get_node("Game")

func _ready() -> void:
	player = get_tree().root.get_node("Game").get_node("Player")
	
func has_decimal(number: float) -> bool:
	return abs(number - int(number)) > 0

func _process(_delta: float) -> void:
	if player:
		player_pos = player.global_position

func make_projectile_instance(target, target_offset, PROJECTILE, projectile_starting_pos, projectile_speed = null):
	# make an arrow instance
	var projectile_instance = PROJECTILE.instantiate()
	projectile_instance.global_position = projectile_starting_pos
	if target is Vector2:
		projectile_instance.look_at(target)
	else:
		projectile_instance.rotation_degrees = target
	projectile_instance.rotation_degrees += randf_range(-target_offset,target_offset)
	if projectile_speed:
		projectile_instance.speed = projectile_speed
	get_tree().root.add_child(projectile_instance)
