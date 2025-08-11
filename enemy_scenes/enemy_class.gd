extends CharacterBody2D
class_name Enemy

var inLineOfSight = false
var inDetectionArea = false
var detected = false

@onready var player_instance: Player = %Player

var player_pos : Vector2

# in this class the enemy is not the player the enemy is the enemy of the player

func _process(delta: float) -> void:
	player_pos = player_instance.global_position

func idle(enemy):
	# stay still
	# idle animation
	
	enemy.direction = Vector2.ZERO
	enemy.animation.play("idle")
	
func chase(enemy: CharacterBody2D):
	enemy.direction = enemy.position.direction_to(player_pos)
	
func check_for_line_of_sight(target_pos: Vector2, enemy_node: CharacterBody2D, line_of_sight: RayCast2D):
	#make the raycast target the player
	var local_target = line_of_sight.to_local(target_pos)
	line_of_sight.set_target_position(local_target)
	
	var line_of_sight_colliders = line_of_sight.get_collider()
	if line_of_sight_colliders is Player:
		return true
	else:
		return false
	
func check_for_transition(enemy: CharacterBody2D, detection_area: Area2D):
	# check if we should chase the player
	var detection_body_collisions = detection_area.get_overlapping_bodies()
	for body in detection_body_collisions:
		if body is Player:
			inDetectionArea = true
		else:
			inDetectionArea = false
	if inDetectionArea or detected:	
		inLineOfSight = check_for_line_of_sight(player_pos, enemy, enemy.line_of_sight_ray)
			
	if inDetectionArea and inLineOfSight:
		detected = true
	else:
		detected = false
			
	print("in detection area: " + str(inDetectionArea))
	print("in line of sight: " + str(inLineOfSight))
	print("detected: " + str(detected))
			
	if detected:
		enemy.current_state = "chase"
	elif detected == false:
		enemy.current_state = "idle"


func update(delta: float, enemy: CharacterBody2D) -> void:
	if enemy.current_state == "idle":
		idle(enemy)
	elif enemy.current_state == "chase":
		chase(enemy)
			
	check_for_transition(enemy,$detection_area)
