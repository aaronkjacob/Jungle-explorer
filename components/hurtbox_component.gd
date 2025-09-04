extends Area2D
class_name HurtboxComponent

var hurtbox = null

func _process(_delta: float) -> void:
	if hurtbox:
		hurtbox.damage()
	

func _on_area_entered(area: Area2D) -> void:
	if get_parent() is Projectile:
		if self.get_parent() is Arrow and area.get_parent() is Player:
			return
			
		if get_parent() is EnemyProjectile and area.get_parent() is Enemy:
			return
		
	if area is HitboxComponent:
		if get_parent() != area.get_parent():
			if area.get_parent().get_parent() != get_parent().get_parent():
				var hitbox : HitboxComponent = area
				var attack = Attack.new()
				attack.damage = 1
				attack.knockback_force = 200
				attack.position = global_position
				hitbox.damage(attack)
				
				if get_parent() is Projectile:
					get_parent().queue_free()
