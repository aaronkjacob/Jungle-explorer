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

func make_projectile_instance(target, target_offset, PROJECTILE, parent):
	# make an arrow instance
	var projectile_instance = PROJECTILE.instantiate()
	get_tree().root.add_child(projectile_instance)
	projectile_instance.global_position = parent.global_position
	if target is Vector2:
		projectile_instance.look_at(target)
	else:
		projectile_instance.rotation = target
	projectile_instance.rotation_degrees += randf_range(-target_offset,target_offset)
