extends Enemy
class_name Slimedashing_timer

@onready var line_of_sight_ray: RayCast2D = $RayCast2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2
@export var normall_speed = 6000
var speed = normall_speed

func _physics_process(delta: float) -> void:
	# update the Enemy class for this object
	update(delta)
	
	# if not taking damage the set the velocity of the enemy
	if not taking_damage:
		velocity = direction * speed * delta

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "hurt":
		animation.play("idle")
		taking_damage = false
		
