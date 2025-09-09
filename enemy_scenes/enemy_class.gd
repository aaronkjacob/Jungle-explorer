extends CharacterBody2D
class_name Enemy

# line of sight, detection area, and detected: all variables that check if the Enemy should follow the player
var inLineOfSight = false
var inDetectionArea = false
var detected = false

# the state of the Enemy, (idle, chasing, attacking)
enum EnemyState { IDLE, CHASE}
var current_state: EnemyState = EnemyState.IDLE

# speed variables
@export var normall_speed = 3000
var speed = normall_speed

# direction
var direction: Vector2

# breadcrum variables
@onready var breadcrum_search_index = len(global.Game_node.get_node("breadcrum_spawner").breadcrum_list) - 1
@onready var breadcrum_list = global.Game_node.get_node("breadcrum_spawner").breadcrum_list


# taking damage bool
var taking_damage = false

# node references
var detection_area: Area2D
var enemy_obj : Enemy
var line_of_sight_ray : RayCast2D
var Enemies_node : Node

var raycast_list = []

# current targeting position
var current_target_pos : Vector2

# in this class the enemy the parameters are referring to is the slime, globlin, scout. (the enemy of the player)

func state_idle():
	if not taking_damage:
		self.direction = Vector2.ZERO
		self.animation.play("idle")

func state_chase():
	self.direction = position.direction_to(current_target_pos)
	#self.animation.play("run")  # Assuming you have a "run" animation
	
func point_raycast2d(raycast : RayCast2D, target_pos):
	var local_target = raycast.to_local(target_pos)
	raycast.set_target_position(local_target)
	line_of_sight_ray.force_raycast_update()
	
func check_for_raycast_collision(raycast):
	return raycast.get_collider()
	
func check_for_breadcrum_collision(index):
	var breadcrum_target = breadcrum_list[index]
	var breadcrum_target_pos = breadcrum_target.global_position
	
	
	for breadcrum in get_tree().root.get_children():
		if breadcrum is Breadcrum:
			if breadcrum != breadcrum_list[index]:
				line_of_sight_ray.add_exception(breadcrum)
			else:
				line_of_sight_ray.remove_exception(breadcrum)
				

	
	point_raycast2d(line_of_sight_ray,breadcrum_target_pos)
	var line_of_sight_colliders = check_for_raycast_collision(line_of_sight_ray)

	if line_of_sight_colliders is Breadcrum:
		return true

	return false

func check_for_player_collision():
	for breadcrum in get_tree().root.get_children():
		if breadcrum is Breadcrum:
			line_of_sight_ray.add_exception(breadcrum)
				

	
	point_raycast2d(line_of_sight_ray,global.player_pos)
	var line_of_sight_colliders = check_for_raycast_collision(line_of_sight_ray)

	if line_of_sight_colliders is Player:
		return true

	return false


func check_for_line_of_sight(_target_pos: Vector2):
	for node in get_tree().root.get_children():
		if node is Projectile:
			for child in node.get_children():
				if child is CollisionObject2D:
					line_of_sight_ray.add_exception(child)

	var index = breadcrum_list.size()
	while true:
		if index == breadcrum_list.size():
			if check_for_player_collision():
				current_target_pos = global.player_pos
		elif check_for_breadcrum_collision(index):
			current_target_pos = breadcrum_list[index].global_position
			return true
		index -= 1
		if index <= 0:
			break

	return false

func print_detection_status():
	print("")
	print(name)
	print("detected: " + str(detected))
	print("line of sight: " + str(inLineOfSight))
	print("detection area: " + str(inDetectionArea))

func check_for_in_detection_area():
	# check if we should chase the player

	var detection_area_collisions = detection_area.get_overlapping_areas()



	for area in detection_area_collisions:
		if area is Breadcrum:
			return true
	return false

func update_detection_area_size():
	if detected or taking_damage:
		detection_area.scale = Vector2(1.5, 1.5)
		
func update_detected():
	if inDetectionArea and inLineOfSight:
		detected = true
	else:
		detected = false


func check_for_transition():
	#print_detection_status()
	
	inDetectionArea = check_for_in_detection_area()

	if inDetectionArea or detected:
		inLineOfSight = check_for_line_of_sight(global.player_pos)

	update_detected()
	
	update_detection_area_size()

	if taking_damage:
		current_state = EnemyState.CHASE  # Or create a DAMAGE state
	elif detected:
		current_state = EnemyState.CHASE
	else:
		current_state = EnemyState.IDLE

func damage(attack: Attack, _enemy):
	velocity += (global_position - attack.position).normalized()*attack.knockback_force
	taking_damage = true

func handle_animation_flip():
	if self.direction.x:
		if self.direction.x < 0:
			self.animation.flip_h = true
		elif self.direction.x > 0:
			self.animation.flip_h = false

func _ready() -> void:
	# define detection_area
	for child in get_children():
		if child is Area2D and child.name == "detection_area":
			detection_area = child
			
	# define line_of_sight
	for child in get_children():
		if child is RayCast2D:
			if child.name == "line_of_sight":
				line_of_sight_ray = child

	line_of_sight_ray.add_exception(global.player)
	for node in global.player.get_children():
		if node is CollisionObject2D:
			line_of_sight_ray.add_exception(node)
			

	# initialize enemy variable
	if self is Enemy:
		enemy_obj = self
		
	# initialize enemies_node_variable
	for node in get_tree().root.get_children():
		if node.name == "Game":
			var game_node = node
			for node2 in game_node.get_children():
				if node2 is Node and node2.name == "enemies":
					Enemies_node = node2


	# add exeptions for line of sight ray
					
	for enemy in Enemies_node.get_children(): # add an exeption for all collision object 2ds from other enemies
		for enemy_child in enemy.get_children():
			if enemy_child is CollisionObject2D:
				line_of_sight_ray.add_exception(enemy_child)
	
	
				


func update(_delta: float) -> void:

	match current_state:
		EnemyState.IDLE:
			state_idle()
		EnemyState.CHASE:
			state_chase()

	handle_animation_flip()
	check_for_transition()
