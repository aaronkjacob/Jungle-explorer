extends CharacterBody2D
class_name Player

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var normall_speed = 8500
@export var dash_speed = 17000
var speed = normall_speed
@export var override_normall_speed = 0

@export var max_health : int = 10



var dashing = false
var dashable = true

var direction : Vector2

@onready var main_body_collision: CollisionShape2D = $main_body_shape

var animation_dir_y = 'front'

var invinsibility_timer = 0
var max_invinxibility = 1.5

var dead = false

var taking_damage = false

func _ready() -> void:
	if override_normall_speed:
		normall_speed = override_normall_speed

func _physics_process(delta: float) -> void:

	# handle input
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")

	#if animation.flip_h == false:
		#$hitboxComponent.scale.x = abs($hitboxComponent.scale.x)
		#$main_body_shape.position.x = abs($main_body_shape.position.x)
	#if animation.flip_h == true:
		#$hitboxComponent.scale.x = abs($hitboxComponent.scale.x) * -1
		#$main_body_shape.position.x = abs($main_body_shape.position.x) * -1
			
	if dead:
		get_tree().reload_current_scene()
	
	# handle what direction you're facing
	if direction.y:
		if direction.y > 0:
			animation_dir_y = 'front'
		if direction.y < 0:
			animation_dir_y = 'back'
			
	
	if direction.x and !direction.y:
		animation_dir_y = 'front'
	
	if invinsibility_timer:
		invinsibility_timer += delta
		if invinsibility_timer >= max_invinxibility:
			invinsibility_timer = 0
	
	# handle animation flip and type
	if not taking_damage:
		if direction:
			animation.play(animation_dir_y + "_run")
			if direction.x > 0:
				animation.flip_h = false
			elif direction.x < 0:
				animation.flip_h = true
		else:
			animation.play(animation_dir_y + "_idle")
	
	if Input.is_action_just_pressed("dash") and dashable:
		dash()

	if taking_damage:
		animation.play(animation_dir_y + "_hurt")

	if not taking_damage:
		velocity = direction * speed * delta
	move_and_slide()

		
func take_damage(attack: Attack):
	velocity += (global_position - attack.position).normalized()*attack.knockback_force
	taking_damage = true
	animation.play(animation_dir_y + "_hurt")
	
func dash():
	speed = dash_speed
	$dashing_timer.start()
	dashable = false
	$dashing_cooldown.start()

func _on_timer_timeout() -> void:
	dashing = false
	speed = normall_speed


func _on_dashing_cooldown_timeout() -> void:
	dashable = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "front_hurt" or animation.animation == "back_hurt":
		animation.play(animation_dir_y + "_run")
		taking_damage = false
