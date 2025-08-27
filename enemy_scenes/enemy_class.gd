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


# taking damage bool
var taking_damage = false

# node references
var detection_area: Area2D
var enemy_obj : Enemy
var line_of_sight : RayCast2D
var Enemies_node : Node


# in this class the enemy the parameters are referring to is the slime, globlin, scout. (the enemy of the player)

func state_idle():
	if not taking_damage:
		self.direction = Vector2.ZERO
		self.animation.play("idle")

func state_chase():
	self.direction = position.direction_to(global.player_pos)
	#self.animation.play("run")  # Assuming you have a "run" animation
	
func check_for_line_of_sight(target_pos: Vector2):
	#make the raycast target the player
	var local_target = line_of_sight.to_local(target_pos)
	line_of_sight.set_target_position(local_target)

	for node in get_tree().root.get_children():
		if node is Projectile:
			for child in node.get_children():
				if child is CollisionObject2D:
					line_of_sight.add_exception(child)


	var line_of_sight_colliders = line_of_sight.get_collider()
	
	if line_of_sight_colliders:
		if line_of_sight_colliders.get_parent() is Player:
			return true
		else:
			return false
	else:
		return false

func print_detection_status():
	print("")
	print(name)
	print("detected: " + str(detected))
	print("line of sight: " + str(inLineOfSight))
	print("detection area: " + str(inDetectionArea))

func check_for_in_detection_area():
	# check if we should chase the player
	
	var detection_body_collisions = detection_area.get_overlapping_bodies()
	


	for body in detection_body_collisions:
		if body is Player:
			return true
	return false

func update_detection_area_size():
	if detected or taking_damage:
		detection_area.scale = Vector2(2, 2)
		
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
			line_of_sight = child

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
				line_of_sight.add_exception(enemy_child)
				


func update(_delta: float) -> void:

	match current_state:
		EnemyState.IDLE:
			state_idle()
		EnemyState.CHASE:
			state_chase()

	handle_animation_flip()
	check_for_transition()
