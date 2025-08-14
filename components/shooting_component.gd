extends Timer
class_name ShootingComponent

@onready var player: Player = get_tree().current_scene.get_node("Player")
var player_pos : Vector2

@export var aim : float = .5

@export var PROJECTILE = preload("res://bow/arrow.tscn")

func _process(_delta: float) -> void:	
	player_pos = player.global_position

func _on_timeout() -> void:
	if get_parent().detected:
		# make an arrow instance
		var arrow_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(arrow_instance)
		arrow_instance.global_position = get_parent().global_position
		arrow_instance.look_at(player_pos)
		arrow_instance.rotation_degrees += randf_range(-aim,aim)
		
		self.start()
