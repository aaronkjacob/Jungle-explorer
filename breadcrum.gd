extends Area2D
class_name Breadcrum

var detectedEnemies = []

var enemy_in_sight = false

@onready var breadcrum_ray: RayCast2D = $breadcrumRay


func _process(_delta: float) -> void:
	for enemy in get_tree().root.get_node("Game").get_node("enemies").get_children():
		if enemy.inDetectionArea:
			detectedEnemies.append(enemy)
			
	for enemy in detectedEnemies:
		if enemy and !enemy.inDetectionArea:
			detectedEnemies.erase(enemy)
			
	for enemy in detectedEnemies:
		var breadcrum_ray_colliders = breadcrum_ray.get_collider()
		enemy.point_line_raycast2d(breadcrum_ray,enemy.global_position)
		breadcrum_ray_colliders = breadcrum_ray.get_collider()
		
		if breadcrum_ray_colliders:
			if breadcrum_ray_colliders.get_parent() is not Enemy:
				get_tree().root.remove_child.call_deferred(self)
				enemy_in_sight = false
			else:
				enemy_in_sight = true
		
		
		
