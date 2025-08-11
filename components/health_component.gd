extends Node2D
class_name HealthComponent

@export var maxHealth = 3
var health : float

func _ready() -> void:
	health = maxHealth
	
func damage(attack: Attack):
	health -= attack.damage
	
	if health <= 0:
		get_parent().queue_free()
			
	get_parent().velocity = (get_parent().global_position - attack.position).normalized()*attack.knockback_force

	if get_parent() == Player:
		get_parent().animation.play("front_hurt")
	else:
		get_parent().animation.play("hurt")
	get_parent().taking_damage = true
