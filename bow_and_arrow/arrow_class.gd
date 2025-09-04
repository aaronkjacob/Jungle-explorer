extends Projectile
class_name Arrow


func _on_hurtbox_component_body_entered(body: Node2D) -> void:
	if body is TileMap:
		queue_free()
