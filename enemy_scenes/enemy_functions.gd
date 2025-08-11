extends Node
var tilemap = null
var player = null

func _ready() -> void:
	tilemap = get_parent().get_child(2).get_child(0)
	player = get_parent().get_child(2).get_child(1)


# this function is for getting  a random point in the circumference of a circle
func get_random_point_on_circumference(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU  # TAU is 2π, a full circle in radians
	var x = center.x + radius * cos(angle)
	var y = center.y + radius * sin(angle)
	return Vector2(x, y)
	
# this function is for moving towards the target
func move_towards_target(target, enemy: CharacterBody2D):
		enemy.direction = enemy.position.direction_to(target)
		
# for this function make sure you have a sight/detetction area boolean to check if you are in the sight area
# also you need a raycast2d that checks for line of sightedge
# this function checks if you have line of sight with the player
func check_for_line_of_sight(target_pos: Vector2, enemy_node: CharacterBody2D, line_of_sight: RayCast2D):
	#make the raycast target the player
	var local_target = line_of_sight.to_local(target_pos)
	line_of_sight.set_target_position(local_target)
	
	# check if player is in line of sight
	var line_Of_Sight_collider = line_of_sight.get_collider()
	if line_Of_Sight_collider != player:
		return false
	elif line_Of_Sight_collider == player:
		return true		
		
# this function checks if you are in the detection area, you need to put the enemy node that is 
# searching for the player, and the detection_area
func check_for_detection_area(targte_pos: Vector2, enemy_node: CharacterBody2D, detection_area: Area2D):
	var detection_area_overlapping_bodies = detection_area.get_overlapping_bodies()
	if player in detection_area_overlapping_bodies:
		return true
	else:
		return false
