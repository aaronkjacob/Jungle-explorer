extends Area2D
class_name dashingComponent

var dashable = true
var dashing = false

@onready var cooldown_wait_timer: Timer = $dash_cooldown
@onready var dashing_timer: Timer = $dashing_time

@export var dash_speed : int = 10000

@export var dashing_cooldown = 1.5
@export var dashing_time = .3

func _ready() -> void:
	cooldown_wait_timer.wait_time = dashing_cooldown
	dashing_timer.wait_time = dashing_time

func _physics_process(_delta: float) -> void:
	
	if dashable:
		var overlapping_bodies = get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is Player:
				dash()

func dash():
	get_parent().speed = dash_speed
	dashing_timer.start()
	dashable = false
	cooldown_wait_timer.start()


func _on_dash_cooldown_timeout() -> void:
	dashable = true


func _on_dashing_time_timeout() -> void:
	dashing = false
	get_parent().speed = get_parent().normall_speed
