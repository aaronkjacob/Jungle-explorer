extends Area2D
class_name HurtboxComponent

var hurtbox = null
@export var damage : int = 1
@export var knockback_force = 200

func _ready() -> void:
	if get_parent() is Projectile:
		damage = get_parent().damage

func _process(_delta: float) -> void:
	if hurtbox:
		hurtbox.damage()
	

func _on_area_entered(area: Area2D) -> void:
	if get_parent() is Projectile:
		if self.get_parent() is Arrow and area.get_parent() is Player:
			return
			
		if get_parent() is EnemyProjectile and area.get_parent() is Enemy:
			return
						
	if get_parent() is Enemy and area.get_parent() is Enemy:
		return
		
	if area is HitboxComponent:
		if get_parent() != area.get_parent():
			if area.get_parent().get_parent() != get_parent().get_parent():
				var hitbox : HitboxComponent = area
				var attack = Attack.new()
				attack.damage = damage
				if get_parent() is Enemy and area.get_parent() is Player:
					damage = get_parent().contact_damage

				attack.knockback_force = knockback_force
				attack.position = global_position
				hitbox.damage(attack)
				
				if get_parent() is Projectile:
					get_parent().queue_free()


func _on_body_entered(body: Node2D) -> void:
	if self.get_parent() is Projectile and body is TileMapLayer:
		get_parent().queue_free()
