extends Node2D
class_name ShootingAttack

@export var Projectile_preload = preload("res://enemy_scenes/enemy_projectiles/poison_ball.tscn")
@export var shooting_cooldown_time : float
@export var projectile_speed : int
@onready var shooting_attack_cooldown_timer: Timer = $shooting_attack_cooldown

var cooling_down = true

func _ready() -> void:
	shooting_attack_cooldown_timer.start()
	if shooting_cooldown_time:
		shooting_attack_cooldown_timer.wait_time = shooting_cooldown_time
	else:
		push_warning("shooting_cooldown_time has no overide; Default time of ", shooting_attack_cooldown_timer.wait_time, " second")
		
func attack():
	if not cooling_down:
		global.make_projectile_instance(global.player_pos,0,Projectile_preload,global_position, projectile_speed)
		cooling_down = true
		shooting_attack_cooldown_timer.start()

func _on_shooting_attack_cooldown_timeout() -> void:
	cooling_down = false
