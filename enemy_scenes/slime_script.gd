extends CharacterBody2D


var direction : Vector2

@onready var player: CharacterBody2D = $"../../Player"

@export var speed = 4000

@onready var line_of_sight: RayCast2D = $lineOfSight

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var movment_smoothening = .05

var detection_area = false
var lineOfSight = false
var detected = false

const target_radius = 60
var target : Vector2

var knockback : Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var attacking = false

var taking_damage = false

var target_offset : Vector2
func _ready() -> void:
	target_offset = enemy_funcs.get_random_point_on_circumference(player.global_position, target_radius) - player.global_position
		
func _physics_process(delta: float) -> void:
	if attacking == false:
		target = player.position + target_offset
	else:
		target = player.position
	

	if detected:	
		enemy_funcs.move_towards_target(target, self)
	else:
		direction = Vector2(0,0)
		

	# check for if in line of sight or in detection area
	lineOfSight = enemy_funcs.check_for_line_of_sight(player.position,self,line_of_sight)
	detection_area = enemy_funcs.check_for_detection_area(player.position, self, $detectionArea)
	
	# of both are true then detected = true
	if detection_area and lineOfSight:
		detected = true
	if not taking_damage:
		velocity = direction * speed * delta
	
	move_and_slide()
	
	
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == $"../../Player":
		attacking = true
func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == $"../../Player":
		attacking = false
		

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "hurt":
		animation.play("idle")
	taking_damage = false



func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if area is HitboxComponent:
			var hitbox : HitboxComponent = area
			var attack = Attack.new()
			attack.damage = 1
			attack.knockback_force = 100
			attack.position = global_position
			
			hitbox.damage(attack)
