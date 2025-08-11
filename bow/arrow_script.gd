extends Node2D

const speed = 300


func _process(delta: float) -> void:
	position += transform.x * speed * delta
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Player:
		if area is HitboxComponent:
			var hitbox : HitboxComponent = area
			var attack = Attack.new()
			attack.damage = 1
			attack.knockback_force = 100
			attack.position = global_position
			
			hitbox.damage(attack)
		queue_free()
