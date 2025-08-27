extends Enemy
class_name Snake

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

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

		
