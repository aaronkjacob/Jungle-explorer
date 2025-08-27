extends EnemyAttacks
class_name ShootAttack


@export var PROJECTILE = preload("res://bow_and_arrow/arrow.tscn")

@export var aim : float = .5

@export var shooting_cooldown : float = 1.0
@onready var shooting_cooldown_timer: Timer = $shooting_cooldown
@export var cooldown_offset_range = .5

var cooling_down = false

func _ready() -> void:
	if get_parent() is not AttacksManager:
		printerr("Self parent is not AttacksManager")
		queue_free()
		return
		
	var shooting_cooldown_offset = randf_range(-cooldown_offset_range,cooldown_offset_range)
	shooting_cooldown_timer.wait_time = shooting_cooldown + shooting_cooldown_offset
	

func attack():
	if not cooling_down:
		global.make_projectile_instance(global.player_pos,aim,PROJECTILE,get_parent().get_parent())
		shooting_cooldown_timer.start()
		cooling_down = true


func _on_shooting_cooldown_timeout() -> void:
	cooling_down = false
