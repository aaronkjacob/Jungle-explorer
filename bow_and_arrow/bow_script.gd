extends Node2D

const ARROW = preload("res://bow_and_arrow/arrow.tscn")
@onready var bow: Node2D = $"."
@onready var player: Player = $".."



var shooting = false
const shooting_delay = 20
var shooting_delay_counter = 0

func _ready() -> void:
	bow.hide()

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	if Input.is_action_just_pressed("shoot") and shooting == false:
		
		global.make_projectile_instance(rotation, 0, ARROW, get_parent())		
		# reset shooting delay counter and set shooting to true
		shooting = true
		shooting_delay_counter = 0
		
		var attack = Attack.new()
		attack.damage = 0
		attack.knockback_force = 50
		attack.position = get_global_mouse_position()
		player.take_damage(attack)
		
	# handle shooting delay
	if shooting_delay_counter > shooting_delay:
		shooting = false
	else:
		shooting = true
		shooting_delay_counter += 1
		
	if shooting == false:
		bow.hide()
	else:
		bow.show()
