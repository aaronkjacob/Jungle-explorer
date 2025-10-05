extends Area2D
class_name Breadcrum

## all this commented out code is just code that I was going to use to ty to make the breadcrum mova away from the tilemap walls


#var raycast_list = []
#var raycast_amount = 4
#var raycast_length = 15
#
#func _ready() -> void:
	#for i in range(1,raycast_amount+1):
		#var new_raycast = RayCast2D.new()
		#new_raycast.global_position = global_position
		#new_raycast.target_position = Vector2i(0,raycast_length)
		#new_raycast.rotation_degrees = i*(360/raycast_amount)
		#
		#raycast_list.append(new_raycast)
		#add_child.call_deferred(new_raycast)
		#
#func _process(delta: float) -> void:
	#if raycast_list:
		#for raycast in raycast_list:
			#var raycast_collider = raycast.get_collider()
			#if raycast_collider is TileMapLayer:
				#var attack = Attack.new()
				#attack.knockback_force = 10
				#attack.damage = 0
				#attack.position = raycast.global_position
				#
				#take_damage(attack)
#
#func take_damage(attack: Attack):
	#global_position += (global_position - attack.position).normalized()*attack.knockback_force * 0
				
